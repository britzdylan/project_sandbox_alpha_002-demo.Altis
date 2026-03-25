// ============================================================
// OSF_fnc_debugOverlay
// Togglable debug HUD overlay. Shows FPS, AI count, game state,
// CP balance, and sector status.
//
// Toggle: Left Ctrl + F12
//
// Called once from fn_boot. Registers the keybind and starts
// the update loop (hidden by default).
//
// Params: none
// Returns: nothing
// Usage:  [] call OSF_fnc_debugOverlay;
// ============================================================

#include "..\..\scripts\constants.hpp"

// State flag — toggled by keybind
missionNamespace setVariable ["OSF_debugOverlayVisible", false];

// Spawn the overlay loop — runs in background, updates every 1s when visible
[] spawn {
    // Wait for display to be ready
    waitUntil { !isNull (findDisplay 46) };

    private _display = findDisplay 46;

    // Create a structured text control on the main game display
    private _ctrl = _display ctrlCreate ["RscStructuredText", 9999];
    _ctrl ctrlSetPosition [
        safeZoneX + safeZoneW * 0.005,    // x — top-left with small margin
        safeZoneY + safeZoneH * 0.005,    // y
        safeZoneW * 0.25,                  // w
        safeZoneH * 0.22                   // h
    ];
    _ctrl ctrlSetBackgroundColor [0, 0, 0, 0.65];
    _ctrl ctrlCommit 0;
    _ctrl ctrlShow false;

    // Register keybind: Left Ctrl + F12 (DIK_F12 = 0x58 = 88)
    _display displayAddEventHandler ["KeyDown", {
        params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
        if (_key == 0x58 && _ctrl) then {
            private _vis = !(missionNamespace getVariable ["OSF_debugOverlayVisible", false]);
            missionNamespace setVariable ["OSF_debugOverlayVisible", _vis];
            true  // consume the key
        } else {
            false
        };
    }];

    // Update loop
    while {true} do {
        private _visible = missionNamespace getVariable ["OSF_debugOverlayVisible", false];
        _ctrl ctrlShow _visible;

        if (_visible) then {
            private _fps = round diag_fps;
            private _aiCount = {alive _x && !isPlayer _x} count allUnits;
            private _phase = [OSF_KEY_CAMPAIGN_PHASE, "?"] call OSF_fnc_getMissionVar;
            private _cp = [OSF_KEY_CP_POINTS, 0] call OSF_fnc_getMissionVar;
            private _failures = [OSF_KEY_OP_FAILURES, 0] call OSF_fnc_getMissionVar;
            private _debug = [OSF_KEY_DEBUG, false] call OSF_fnc_getMissionVar;

            // Sector summary — count by status
            private _sectorReg = [OSF_KEY_SECTOR_STATE, createHashMap] call OSF_fnc_getMissionVar;
            private _libCount = 0;
            private _conCount = 0;
            private _occCount = 0;
            {
                private _status = _x getOrDefault ["status", "unknown"];
                switch (_status) do {
                    case "liberated":  { _libCount = _libCount + 1 };
                    case "contested":  { _conCount = _conCount + 1 };
                    case "occupied":   { _occCount = _occCount + 1 };
                };
            } forEach (values _sectorReg);

            private _color = if (_fps >= 30) then { "#88cc88" } else { "#cc4444" };

            private _text = format [
                "<t size='0.85' font='EtelkaMonospacePro' color='#aabb99'>--- OSF DEBUG ---</t><br/>" +
                "<t size='0.8' font='EtelkaMonospacePro' color='%1'>FPS: %2</t><br/>" +
                "<t size='0.8' font='EtelkaMonospacePro' color='#aabb99'>AI:  %3</t><br/>" +
                "<t size='0.8' font='EtelkaMonospacePro' color='#aabb99'>Phase: %4  |  CP: %5</t><br/>" +
                "<t size='0.8' font='EtelkaMonospacePro' color='#aabb99'>Failures: %6 / 3</t><br/>" +
                "<t size='0.8' font='EtelkaMonospacePro' color='#aabb99'>Sectors: %7L %8C %9O</t><br/>" +
                "<t size='0.8' font='EtelkaMonospacePro' color='#667755'>Ctrl+F12 to close</t>",
                _color, _fps, _aiCount, _phase, _cp, _failures,
                _libCount, _conCount, _occCount
            ];

            _ctrl ctrlSetStructuredText parseText _text;
        };

        sleep 1;
    };
};

["boot", "Debug overlay initialized (Ctrl+F12 to toggle).", OSF_LOG_INFO] call OSF_fnc_log;
