// ============================================================
// OSF_fnc_boot
// Bootstraps all global game state on mission start.
// Called once from init.sqf before player-dependent code.
//
// Init order:
//   1. World settings
//   2. Global state vars
//   3. Log verbosity map
//   4. Sector state (from data or save)
//   5. ODA roster
//   6. TOC interactions
//   7. Upgrade tree
//   8. CBA event registration
//   9. Debug overlay
//
// params: none
// Returns: nothing
// Usage:  [] call OSF_fnc_boot;
// ============================================================

#include "..\..\scripts\constants.hpp"

params [];

["boot", "starting...", OSF_LOG_INFO] call OSF_fnc_log;

// ---- 1. World settings ----
setTimeMultiplier OSF_TIME_MULTIPLIER;

// ---- 2. Global state vars ----
// Always initialized fresh; persisted separately by fn_saveState / fn_loadState.
[OSF_KEY_DEBUG,           true] call OSF_fnc_setMissionVar;   // set false for release
[OSF_KEY_OP_FAILURES,       0] call OSF_fnc_setMissionVar;   // game over at 3
[OSF_KEY_CAMPAIGN_PHASE,    1] call OSF_fnc_setMissionVar;   // 1=early, 2=mid, 3=late
[OSF_KEY_ASSET_INVENTORY,  []] call OSF_fnc_setMissionVar;   // populated by requisition system (B5)

// ---- 3. Log verbosity map ----
// Per-domain threshold: 0=off, 1=error, 2=warn, 3=info, 4=verbose
// Adjust during development; set all to 1-2 for release.
private _verbosity = createHashMapFromArray [
    ["boot",       OSF_LOG_INFO],
    ["oda",        OSF_LOG_INFO],
    ["sectors",    OSF_LOG_INFO],
    ["toc",        OSF_LOG_INFO],
    ["save",       OSF_LOG_INFO],
    ["militia",    OSF_LOG_INFO],
    ["menu",       OSF_LOG_WARN],
    ["operations", OSF_LOG_INFO],
    ["utils",      OSF_LOG_WARN]
];
missionNamespace setVariable ["OSF_logVerbosity", _verbosity];

// ---- 4. Sector state ----
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
// ["boot", format ["%1 sector(s) initialized.", count (keys _registry)], OSF_LOG_INFO] call OSF_fnc_log;

// ---- 5. ODA roster ----
[] call OSF_fnc_odaInit;

// ---- 6. TOC interactions ----
[] call OSF_fnc_tocInit;

// ---- 7. Upgrade tree ----
[] call OSF_fnc_upgradeInit;

// ---- 8. CBA event registration ----
// Listeners are registered here so all handlers are centralized.
// Fire events from domain code: [OSF_EVT_SECTOR_LIBERATED, [_sectorId]] call CBA_fnc_localEvent;
// Handlers added below — uncomment and implement as each system comes online.

// [OSF_EVT_SECTOR_LIBERATED, {
//     params ["_sectorId"];
//     ["events", format ["Sector liberated: %1", _sectorId], OSF_LOG_INFO] call OSF_fnc_log;
//     // TODO: trigger FIA camp spawn, HUMINT availability, counter-attack timer
// }] call CBA_fnc_addEventHandler;

// [OSF_EVT_SECTOR_LOST, {
//     params ["_sectorId"];
//     ["events", format ["Sector lost: %1", _sectorId], OSF_LOG_WARN] call OSF_fnc_log;
//     // TODO: HUMINT lockout, FIA camp removal
// }] call CBA_fnc_addEventHandler;

// [OSF_EVT_CP_CHANGED, {
//     params ["_newBalance"];
//     ["events", format ["CP changed: %1", _newBalance], OSF_LOG_INFO] call OSF_fnc_log;
//     // TODO: UI update
// }] call CBA_fnc_addEventHandler;

// [OSF_EVT_OPERATION_COMPLETE, {
//     params ["_operationId"];
//     ["events", format ["Operation complete: %1", _operationId], OSF_LOG_INFO] call OSF_fnc_log;
//     // TODO: sector state change, CP award
// }] call CBA_fnc_addEventHandler;

// [OSF_EVT_OPERATION_FAILED, {
//     params ["_operationId"];
//     ["events", format ["Operation failed: %1", _operationId], OSF_LOG_WARN] call OSF_fnc_log;
//     // TODO: fail counter increment
// }] call CBA_fnc_addEventHandler;

// [OSF_EVT_QUEST_STATE_CHANGED, {
//     params ["_questId", "_newState"];
//     ["events", format ["Quest %1 -> %2", _questId, _newState], OSF_LOG_INFO] call OSF_fnc_log;
//     // TODO: task UI update, diary entry
// }] call CBA_fnc_addEventHandler;

["boot", "CBA events defined (handlers commented until systems are built).", OSF_LOG_INFO] call OSF_fnc_log;

// ---- 9. Debug overlay ----
[] call OSF_fnc_debugOverlay;

["boot", "complete.", OSF_LOG_INFO] call OSF_fnc_log;
