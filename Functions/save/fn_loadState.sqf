// ============================================================
// OSF_fnc_loadState
// Restores all domain states from a profileNamespace save blob.
// Called by fn_boot when OSF_saveExists is true.
//
// Validates schema version, checks for missing/corrupt fields,
// and applies defaults where needed. Object references (unitRef,
// hbqModules, militia) are re-seeded empty — owning systems
// re-populate them after load.
//
// Params: none
// Returns: true if load succeeded, false otherwise
// Usage:  private _ok = [] call OSF_fnc_loadState;
// ============================================================

#include "..\..\scripts\constants.hpp"

params [];

private _save = [OSF_PROFILE_SAVE_DATA, createHashMap] call OSF_fnc_getProfileVar;

// ---- Validate blob exists ----
if (count keys _save == 0) exitWith {
    ["save", "Load aborted — save data is empty.", OSF_LOG_ERROR] call OSF_fnc_log;
    false
};

// ---- Validate version ----
private _version = _save getOrDefault ["version", 0];
if (_version != OSF_SAVE_VERSION) exitWith {
    ["save", format ["Load aborted — save version %1 != expected %2. Migration needed.",
        _version, OSF_SAVE_VERSION], OSF_LOG_ERROR] call OSF_fnc_log;
    false
};

["save", format ["Loading save (version %1)...", _version], OSF_LOG_INFO] call OSF_fnc_log;

// ---- Meta ----
[OSF_KEY_OP_FAILURES,    _save getOrDefault ["operationFailures", 0]] call OSF_fnc_setMissionVar;
[OSF_KEY_CAMPAIGN_PHASE, _save getOrDefault ["campaignPhase", 1]]     call OSF_fnc_setMissionVar;
[OSF_KEY_CP_POINTS,      _save getOrDefault ["cpPoints", 0]]          call OSF_fnc_setMissionVar;
[OSF_KEY_ASSET_INVENTORY,_save getOrDefault ["assetInventory", []]]   call OSF_fnc_setMissionVar;

// ---- Sectors ----
private _sectorSave = _save getOrDefault ["sectors", createHashMap];
private _sectorReg = createHashMap;
{
    private _sectorId = _x;
    private _sectorData = _y;

    // Re-seed runtime-only fields
    _sectorData set ["militia", []];
    _sectorData set ["hbqModules", []];
    _sectorData set ["completedSideObjectives", _sectorData getOrDefault ["completedSideObjectives", []]];
    _sectorData set ["counterattackActive", _sectorData getOrDefault ["counterattackActive", false]];

    _sectorReg set [_sectorId, _sectorData];
} forEach _sectorSave;
[OSF_KEY_SECTOR_STATE, _sectorReg] call OSF_fnc_setMissionVar;

// Restore map markers
{
    [_x] call OSF_fnc_updateMarker;
} forEach (keys _sectorReg);

["save", format ["%1 sector(s) restored.", count _sectorReg], OSF_LOG_INFO] call OSF_fnc_log;

// ---- ODA Roster ----
private _odaSave = _save getOrDefault ["odaRoster", createHashMap];
{
    private _slotId = _x;
    private _slotData = _y;

    // Re-seed runtime-only object ref
    _slotData set [OSF_ODA_UNIT_REF, objNull];

    // Validate critical fields with defaults
    _slotData set [OSF_ODA_STATUS, _slotData getOrDefault [OSF_ODA_STATUS, OSF_ODA_STATUS_INACTIVE]];
    _slotData set [OSF_ODA_INCAPACITATED_TIMER, _slotData getOrDefault [OSF_ODA_INCAPACITATED_TIMER, -1]];
    _slotData set [OSF_ODA_REPLACEMENT_TIMER, _slotData getOrDefault [OSF_ODA_REPLACEMENT_TIMER, -1]];

    _odaSave set [_slotId, _slotData];
} forEach _odaSave;
[OSF_KEY_ODA_ROSTER, _odaSave] call OSF_fnc_setMissionVar;

["save", format ["%1 ODA slot(s) restored.", count _odaSave], OSF_LOG_INFO] call OSF_fnc_log;

// ---- Upgrades ----
private _upgradeSave = _save getOrDefault ["upgrades", createHashMap];
[OSF_KEY_UPGRADE_STATE, _upgradeSave] call OSF_fnc_setMissionVar;

["save", format ["%1 upgrade node(s) restored. CP: %2.",
    count _upgradeSave, _save getOrDefault ["cpPoints", 0]], OSF_LOG_INFO] call OSF_fnc_log;

// ---- Player loadout ----
// Applied after player object is ready (deferred to init.sqf waitUntil block)
private _playerLoadout = _save getOrDefault ["playerLoadout", []];
if (count _playerLoadout > 0) then {
    missionNamespace setVariable ["OSF_pendingPlayerLoadout", _playerLoadout];
    ["save", "Player loadout queued for application after player ready.", OSF_LOG_INFO] call OSF_fnc_log;
};

["save", "Load complete.", OSF_LOG_INFO] call OSF_fnc_log;
true
