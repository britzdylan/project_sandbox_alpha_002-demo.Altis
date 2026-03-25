// ============================================================
// OSF_fnc_playerRespawn
// Custom player respawn system. On fatal damage:
//   1. Prevent actual death (sub-lethal damage return)
//   2. Black screen + text
//   3. Heal and teleport player to TOC
//   4. Teleport living squad members to TOC
//
// Call once after player is ready to register the handleDamage EH.
//
// Params: none
// Returns: nothing
// Usage:  [] call OSF_fnc_playerRespawn;
// ============================================================

#include "..\..\scripts\constants.hpp"

// Guard against double-registration
if (player getVariable ["OSF_respawnEHRegistered", false]) exitWith {};
player setVariable ["OSF_respawnEHRegistered", true];

player addEventHandler ["handleDamage", {
    params ["_unit", "_selection", "_damage"];

    // Not fatal — pass through
    if (_damage < 1) exitWith { _damage };

    // Already in respawn sequence — block all damage
    if (_unit getVariable ["OSF_respawnInProgress", false]) exitWith { 0 };

    // ---- Trigger respawn sequence ----
    _unit setVariable ["OSF_respawnInProgress", true];

    [] spawn {
        private _unit = player;

        // Freeze player
        _unit allowDamage false;
        _unit enableSimulation false;

        // Black screen
        cutText ["", "BLACK OUT", 1];
        sleep 1;

        // Get TOC position
        private _tocReg = [OSF_KEY_TOC_STATE, createHashMap] call OSF_fnc_getMissionVar;
        private _tocPos = [0, 0, 0];
        {
            _tocPos = _y getOrDefault [OSF_TOC_POS, [0, 0, 0]];
        } forEach _tocReg;  // Use first TOC found

        // Show message during black screen
        titleText ["You have been critically wounded.\nMEDEVAC to TOC.", "PLAIN", 0.5];
        sleep 2;

        // Teleport and heal player
        _unit setPos _tocPos;
        _unit setDamage 0;
        _unit allowDamage true;
        _unit enableSimulation true;

        // Teleport living squad members nearby
        {
            if (alive _x && _x != player) then {
                private _offset = [_tocPos select 0, _tocPos select 1, 0] vectorAdd [3 + random 5 - 4, 3 + random 5 - 4, 0];
                _x setPos _offset;
            };
        } forEach (units group player);

        // Fade in
        sleep 0.5;
        cutText ["", "BLACK IN", 2];
        titleText ["", "PLAIN"];

        _unit setVariable ["OSF_respawnInProgress", false];

        ["core", "Player respawned at TOC.", OSF_LOG_INFO] call OSF_fnc_log;
    };

    // Return sub-lethal damage to prevent actual death
    0.9
}];

["core", "Player respawn system registered.", OSF_LOG_INFO] call OSF_fnc_log;
