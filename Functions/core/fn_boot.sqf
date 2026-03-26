// ============================================================
// OSF_fnc_boot
// Bootstraps all global game state on mission start.
// Called from init.sqf with the player's startup menu choice.
//
// Phase 1 (pre-display): world settings, debug flag, log verbosity
//   — runs before player is ready, called with no args
// Phase 2 (post-menu): domain init based on player choice
//   — runs after startup menu, called with ["continue"] or ["newgame"]
//
// Init order (Phase 2):
//   1. Save/Load branch (restore or fresh init)
//   2. TOC interactions
//   3. CBA event registration
//   4. Debug overlay
//
// Params: [choice (string, optional — "" for phase 1, "continue"/"newgame" for phase 2)]
// Returns: nothing
// Usage:  [] call OSF_fnc_boot;              // phase 1
//         ["newgame"] call OSF_fnc_boot;     // phase 2
// ============================================================

#include "..\..\scripts\constants.hpp"

params [["_choice", ""]];

// ============================================================
// PHASE 1 — Pre-display setup (no args)
// ============================================================
if (_choice == "") exitWith {
    ["boot", "Phase 1 — pre-display init...", OSF_LOG_INFO] call OSF_fnc_log;

    // ---- World settings ----
    setTimeMultiplier OSF_TIME_MULTIPLIER;
    setDate [2035,3,24,3,21];

    // ---- Debug flag ----
    [OSF_KEY_DEBUG, true] call OSF_fnc_setMissionVar;   // set false for release

    // ---- Log verbosity map ----
    private _verbosity = createHashMapFromArray [
        ["boot",       OSF_LOG_INFO],
        ["oda",        OSF_LOG_INFO],
        ["sectors",    OSF_LOG_INFO],
        ["toc",        OSF_LOG_INFO],
        ["save",       OSF_LOG_INFO],
        ["militia",    OSF_LOG_INFO],
        ["menu",       OSF_LOG_WARN],
        ["operations", OSF_LOG_INFO],
        ["utils",      OSF_LOG_WARN],
        ["events",     OSF_LOG_INFO],
        ["task",        OSF_LOG_INFO]
    ];
    missionNamespace setVariable ["OSF_logVerbosity", _verbosity];

    // ---- Task registry ----
    private _taskRegistry = call compile preprocessFileLineNumbers "scripts\data\taskData.sqf";
    [OSF_KEY_TASK_REGISTRY, _taskRegistry] call OSF_fnc_setMissionVar;
    [OSF_KEY_TASK_STATES, createHashMap] call OSF_fnc_setMissionVar;

    ["boot", "Phase 1 complete.", OSF_LOG_INFO] call OSF_fnc_log;
};

// ============================================================
// PHASE 2 — Domain init (after startup menu choice)
// ============================================================
["boot", format ["Phase 2 — domain init (choice: %1)...", _choice], OSF_LOG_INFO] call OSF_fnc_log;

if (_choice == "continue") then {
    // ---- Restore from save ----
    private _loaded = [] call OSF_fnc_loadState;

    if (_loaded) then {
        ["boot", "Save restored.", OSF_LOG_INFO] call OSF_fnc_log;

        // Re-spawn ODA units from restored roster state
        private _roster = [OSF_KEY_ODA_ROSTER, createHashMap] call OSF_fnc_getMissionVar;
        {
            private _slotId = _x;
            private _slot = _y;
            private _status = _slot getOrDefault [OSF_ODA_STATUS, OSF_ODA_STATUS_INACTIVE];

            if (_status == OSF_ODA_STATUS_ACTIVE) then {
                [_slotId] call OSF_fnc_odaSpawn;
            };

            if (_status == OSF_ODA_STATUS_REDEPLOYMENT) then {
                [_slotId] spawn OSF_fnc_odaReplacementWatcher;
            };
        } forEach _roster;

        ["boot", format ["%1 ODA slot(s) restored from save.", count _roster], OSF_LOG_INFO] call OSF_fnc_log;

        // Upgrade defs are static — reload from file
        private _nodeDefs = call compile preProcessFileLineNumbers "scripts\data\upgradeData.sqf";
        private _defsIndex = createHashMapFromArray (_nodeDefs apply { [_x select 0, _x] });
        [OSF_KEY_UPGRADE_DEFS, _defsIndex] call OSF_fnc_setMissionVar;
    } else {
        // Load failed — treat as new game
        ["boot", "Save load failed — falling back to new game.", OSF_LOG_WARN] call OSF_fnc_log;
        _choice = "newgame";
    };
};

if (_choice == "newgame") then {
    // ---- Set player ----
    // ---- Wipe any existing save ----
    [OSF_PROFILE_SAVE_EXISTS, false] call OSF_fnc_setProfileVar;
    [OSF_PROFILE_SAVE_DATA, createHashMap] call OSF_fnc_setProfileVar;
    saveProfileNamespace;

    // ---- Fresh game state ----
    [OSF_KEY_OP_FAILURES,       0] call OSF_fnc_setMissionVar;
    [OSF_KEY_CAMPAIGN_PHASE,    1] call OSF_fnc_setMissionVar;
    [OSF_KEY_ASSET_INVENTORY,  []] call OSF_fnc_setMissionVar;
    [OSF_KEY_CP_POINTS,         0] call OSF_fnc_setMissionVar;

    // Sector state from data
    // TODO: uncomment when sector system is active
    // private _sectorDefs = call compile preProcessFileLineNumbers "scripts\data\sectorData.sqf";
    // private _registry = createHashMap;
    // {
    //     private _def = _x;
    //     private _sectorMap = createHashMapFromArray [
    //         ["id", _def select 0],
    //         ["displayName", _def select 1],
    //         ["operationId", _def select 2],
    //         ["boundaryMarker", _def select 3],
    //         ["status", _def select 4],
    //         ["adjacency", _def select 5],
    //         ["commandPoints", _def select 6],
    //         ["importance", _def select 7],
    //         ["sideObjectives", _def select 8],
    //         ["completedSideObjectives", []],
    //         ["counterattackActive", false]
    //     ];
    //     _registry set [_def select 0, _sectorMap];
    // } forEach _sectorDefs;
    // [OSF_KEY_SECTOR_STATE, _registry] call OSF_fnc_setMissionVar;
    // {
    //     [_x] call OSF_fnc_updateMarker;
    // } forEach (keys _registry);

    // ODA roster — fresh from data
    [] call OSF_fnc_odaInit;

    // Upgrade tree — fresh
    [] spawn OSF_fnc_upgradeInit;

    ["boot", "Fresh game initialized.", OSF_LOG_INFO] call OSF_fnc_log;
};

// ---- TOC — always from data (object refs don't persist) ----
[] spawn OSF_fnc_tocInit;

// ---- CBA event registration ----
// Autosave on sector liberation
[OSF_EVT_SECTOR_LIBERATED, {
    params ["_sectorId"];
    ["events", format ["Sector liberated: %1", _sectorId], 3] call OSF_fnc_log;
    ["auto"] call OSF_fnc_saveState;
}] call CBA_fnc_addEventHandler;

// [OSF_EVT_SECTOR_LOST, {
//     params ["_sectorId"];
//     ["events", format ["Sector lost: %1", _sectorId], 2] call OSF_fnc_log;
// }] call CBA_fnc_addEventHandler;

// [OSF_EVT_CP_CHANGED, {
//     params ["_newBalance"];
//     ["events", format ["CP changed: %1", _newBalance], 3] call OSF_fnc_log;
// }] call CBA_fnc_addEventHandler;

// Autosave on operation complete
[OSF_EVT_OPERATION_COMPLETE, {
    params ["_operationId"];
    ["events", format ["Operation complete: %1", _operationId], 3] call OSF_fnc_log;
    ["auto"] call OSF_fnc_saveState;
}] call CBA_fnc_addEventHandler;

// [OSF_EVT_OPERATION_FAILED, {
//     params ["_operationId"];
//     ["events", format ["Operation failed: %1", _operationId], 2] call OSF_fnc_log;
// }] call CBA_fnc_addEventHandler;

// Autosave on quest complete (covers HUMINT)
[OSF_EVT_QUEST_STATE_CHANGED, {
    params ["_questId", "_newState"];
    ["events", format ["Quest %1 -> %2", _questId, _newState], 3] call OSF_fnc_log;
    if (_newState in ["SUCCEEDED", "FAILED", "CANCELED"]) then {
        ["auto"] call OSF_fnc_saveState;
    };
}] call CBA_fnc_addEventHandler;

["boot", "CBA events registered.", OSF_LOG_INFO] call OSF_fnc_log;

// ---- Environment ----
[] spawn OSF_fnc_weatherCycle;

// ---- Debug overlay ----
[] spawn OSF_fnc_debugOverlay;

["boot", "Phase 2 complete.", OSF_LOG_INFO] call OSF_fnc_log;
