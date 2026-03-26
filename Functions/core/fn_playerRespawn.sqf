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
// Call once after player is ready to register the EHs.
//
// Params: none
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
        sleep 1;

        // Get TOC position
        private _tocReg = [OSF_KEY_TOC_STATE, createHashMap] call OSF_fnc_getMissionVar;
        private _tocPos = OSF_TOC_SPAWN_POS_001;
        {
            _tocPos = _y getOrDefault [OSF_TOC_POS, OSF_TOC_SPAWN_POS_001];
        } forEach _tocReg;

        // Show message during black screen
        private _text = ["You have been critically wounded.\nMEDEVAC to TOC."] call OSF_fnc_titleText;
        titleText [_text, "PLAIN", true, true];
        sleep 2;

        // Teleport and heal player
        player setPos _tocPos;
        player setDamage 0;
        player enableSimulation true;
        player allowDamage true;

        // Teleport living squad members nearby
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

        // Fade in
        sleep 0.5;
        ["respawn"] call BIS_fnc_blackIn;
        3 fadeSound 1;

        player setVariable ["OSF_respawnInProgress", false];

        ["core", "Player respawned at TOC.", OSF_LOG_INFO] call OSF_fnc_log;
    };
};

// ---- Primary: handleDamage EH ----
// Intercepts fatal hits before death. Returns 0 and disables damage immediately.
player addEventHandler ["handleDamage", {
    params ["_unit", "_selection", "_damage"];

    // Already in respawn — block everything
    if (_unit getVariable ["OSF_respawnInProgress", false]) exitWith { 0 };

    // Not fatal — pass through
    if (_damage < 1) exitWith { _damage };

    // Fatal hit — block it and trigger respawn
    _unit allowDamage false;
    [] call OSF_fnc_doPlayerRespawn;
    0
}];

// ---- Failsafe: killed EH ----
// If something bypasses handleDamage (explosions, collision, engine quirks),
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
