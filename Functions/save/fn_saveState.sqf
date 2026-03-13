// ============================================================
// OSF_fnc_saveState
// Serializes all sector runtime state to profileNamespace.
//
// Object reference fields (militia groups, hbqModules) are intentionally
// excluded — they are invalid across session boundaries.
// Militia allocations are saved separately by the militia system.
//
// Params: none
// Returns: nothing
// Usage:  [] call OSF_fnc_saveState;
// ============================================================

#include "..\..\scripts\constants.hpp"

params [];

private _registry = [OSF_KEY_SECTOR_STATE, createHashMap] call OSF_fnc_getMissionVar;

// Fields safe to persist — order must match fn_loadState exactly
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

private _saveData = [];

{
    private _sectorID  = _x;
    private _sectorMap = _registry get _sectorID;
    private _entry     = [];

    {
        _entry pushBack (_sectorMap getOrDefault [_x, ""]);
    } forEach _safeFields;

    _saveData pushBack [_sectorID, _entry];
} forEach (keys _registry);

[OSF_PROFILE_SECTOR_SAVE, _saveData] call OSF_fnc_setProfileVar;
[OSF_PROFILE_SAVE_EXISTS, true]      call OSF_fnc_setProfileVar;
saveProfileNamespace;

["saveState", format ["Game state saved. %1 sector(s) written.", count _saveData]] call OSF_fnc_log;
