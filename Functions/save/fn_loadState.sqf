// ============================================================
// OSF_fnc_loadState
// Restores sector state from profileNamespace.
// Called by fn_initGameState when OSF_saveExists is true.
//
// Object reference fields (militia, hbqModules) are re-seeded as empty
// arrays — the militia system re-spawns units from its own saved
// allocation data, and hbqModules are re-registered by init.sqf
// every load from Eden variable names.
//
// Field order must exactly mirror fn_saveState._safeFields.
//
// Params: none
// Returns: nothing
// Usage:  [] call OSF_fnc_loadState;  (called internally by initGameState)
// ============================================================

#include "..\..\scripts\constants.hpp"

params [];

private _saveData = [OSF_PROFILE_SECTOR_SAVE, []] call OSF_fnc_getProfileVar;

if (count _saveData == 0) exitWith {
    ["loadState", "save data is empty. Aborting load."] call OSF_fnc_log;
};

// Must match order in fn_saveState exactly
private _safeFields = [
    "id",
    "displayName",
    "poiPos",
    "boundaryMarker",
    "status",
    "adjacency",
    "commandPoints",
    "importance",
    "sideObjectives",
    "completedSideObjectives",
    "counterattackActive"
];

private _registry = createHashMap;

{
    private _entry    = _x;
    private _sectorID = _entry select 0;
    private _values   = _entry select 1;

    private _sectorMap = createHashMap;

    {
        _sectorMap set [_safeFields select _forEachIndex, _x];
    } forEach _values;

    // Re-seed object reference fields — populated by other systems post-load
    _sectorMap set ["militia",    []];
    _sectorMap set ["hbqModules", []];

    _registry set [_sectorID, _sectorMap];
} forEach _saveData;

[OSF_KEY_SECTOR_STATE, _registry] call OSF_fnc_setMissionVar;

// Restore map markers to match saved status
{
    [_x] call OSF_fnc_updateMarker;
} forEach (keys _registry);

["loadState", format ["Game state loaded. %1 sector(s) restored.", count _saveData]] call OSF_fnc_log;
