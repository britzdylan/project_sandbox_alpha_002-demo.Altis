// ============================================================
// OSF_fnc_playerRespawn
// Custom player respawn system. On fatal damage:
//   1. Block the killing blow (return 0, allowDamage false)
//   2. Black screen + text
//   3. Heal and teleport player to TOC
//   4. Teleport living squad members to TOC
// 
// Uses handleDamage EH as primary intercept + killed EH as failsafe.
// 
// call once after player is ready to register the EHs.
// 
// params: none
// Returns: nothing
// Usage:  [] call OSF_fnc_playerRespawn;
// ============================================================

#include "..\..\scripts\constants.hpp"

// Guard against double-registration
if (player getVariable ["OSF_respawnEHRegistered", false]) exitWith {};
player setVariable ["OSF_respawnEHRegistered", true];

// ---- Shared respawn logic (called from both EHs) ----
OSF_fnc_doPlayerRespawn = {
	if (player getVariable ["OSF_respawnInProgress", false]) exitWith {};
	player setVariable ["OSF_respawnInProgress", true];

	    // Immediately make invincible
	player allowDamage false;
	player enableSimulation false;

	["respawn", false] call BIS_fnc_blackOut;

	[] spawn {
		// Fade sound to muffled heartbeat feel
		0.5 fadeSound 0.05;
		sleep 1.5;

		        // Phase 1 — "You're hit" message, hold on black
		private _text1 = ["You have been critically wounded.", 1.8, "#cc3333"] call OSF_fnc_titleText;
		titleText [_text1, "PLAIN", 3, true, true];
		sleep 3;

		        // Phase 2 — MEDEVAC message
		private _text2 = ["Requesting MEDEVAC...", 1.4, "#cccccc"] call OSF_fnc_titleText;
		titleText [_text2, "PLAIN", 3, true, true];
		sleep 2.5;

		        // get TOC position
		private _tocReg = [OSF_KEY_TOC_STATE, createHashMap] call OSF_fnc_getMissionVar;
		private _tocPos = OSF_TOC_SPAWN_POS_001;
		{
			_tocPos = _y getOrDefault [OSF_TOC_POS, OSF_TOC_SPAWN_POS_001];
		} forEach _tocReg;

		        // Teleport and heal player
		player setPos _tocPos;
		player setDamage 0;

		        // Teleport living squad members nearby
		// TODO: move units into pre placed pos with ambient animations.
		// remove from player control
		// player will move to group and they will auto join
		{
			if (alive _x && _x != player) then {
				private _offset = [
					(_tocPos select 0) + (random 8) - 4,
					(_tocPos select 1) + (random 8) - 4,
					0
				];
				_x setPos _offset;
			};
		} forEach (units group player);

		sleep 1;

		// Phase 3 — Wake up at TOC
		private _text3 = ["A FEW HOURS LATER...", 1.6] call OSF_fnc_titleText;
		titleText [_text3, "PLAIN", 2, true, true];
		skipTime 3;
		sleep 3;
		// Start lying down — player wakes up from prone
		player switchMove "AinjPpneMstpSnonWrflDnon";
		["respawn"] call BIS_fnc_blackIn;
		sleep 1;

		// Re-enable player in prone/recovering pose before fade-in
		player enableSimulation true;
		player allowDamage true;

		8 fadeSound 1;

		player setVariable ["OSF_respawnInProgress", false];

		["core", "Player respawned at TOC.", OSF_LOG_INFO] call OSF_fnc_log;
	};
};

// ---- Failsafe: killed EH ----
// if something bypasses handleDamage (explosions, collision, engine quirks),
// this catches the death and forces a respawn.
player addEventHandler ["killed", {
	params ["_unit"];

	["core", "Player killed despite handleDamage — failsafe triggered.", OSF_LOG_WARN] call OSF_fnc_log;

	    // Force revive the corpse
	_unit setDamage 0;
	_unit setUnconscious false;

	[] call OSF_fnc_doPlayerRespawn;
}];

["core", "Player respawn system registered.", OSF_LOG_INFO] call OSF_fnc_log;