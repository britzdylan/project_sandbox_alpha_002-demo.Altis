// ============================================================
// OSF_fnc_saveState
// Serializes all domain states into a single hashmap and writes
// it to profileNamespace. Called from TOC save action or autosave.
//
// Save schema (version 1):
//   "version"          — (number)  schema version for migration
//   "operationFailures"— (number)  0-3
//   "campaignPhase"    — (number)  1/2/3
//   "cpPoints"         — (number)  command points balance
//   "assetInventory"   — (array)   unlocked asset classnames
//   "sectors"          — (hashmap) sectorId → stripped sector hashmap
//   "odaRoster"        — (hashmap) slotId → stripped slot hashmap
//   "upgrades"         — (hashmap) nodeId → boolean
//   "playerLoadout"    — (array)   getUnitLoadout result
//
// Object references (unitRef, hbqModules, militia groups) are
// excluded — they are invalid across session boundaries.
//
// Params: [source (string, optional — "manual" or "auto", for logging)]
// Returns: nothing
// Usage:  ["manual"] call OSF_fnc_saveState;
//         ["auto"] call OSF_fnc_saveState;
// ============================================================

#include "..\..\scripts\constants.hpp"

params [["_source", "manual"]];

private _save = createHashMap;

// ---- Meta ----
_save set ["version", OSF_SAVE_VERSION];
_save set ["operationFailures", [OSF_KEY_OP_FAILURES, 0] call OSF_fnc_getMissionVar];
_save set ["campaignPhase", [OSF_KEY_CAMPAIGN_PHASE, 1] call OSF_fnc_getMissionVar];
_save set ["cpPoints", [OSF_KEY_CP_POINTS, 0] call OSF_fnc_getMissionVar];
_save set ["assetInventory", [OSF_KEY_ASSET_INVENTORY, []] call OSF_fnc_getMissionVar];

// ---- Sectors ----
// Strip object-reference fields; keep only persistable data
private _sectorReg = [OSF_KEY_SECTOR_STATE, createHashMap] call OSF_fnc_getMissionVar;
private _sectorSave = createHashMap;
{
    private _sectorId = _x;
    private _sectorMap = _y;
    private _stripped = createHashMap;
    {
        // Skip runtime-only fields
        if !(_x in ["militia", "hbqModules"]) then {
            _stripped set [_x, _y];
        };
    } forEach _sectorMap;
    _sectorSave set [_sectorId, _stripped];
} forEach _sectorReg;
_save set ["sectors", _sectorSave];

// ---- ODA Roster ----
// Save status, loadout, timers per slot. Exclude unitRef (object).
private _odaReg = [OSF_KEY_ODA_ROSTER, createHashMap] call OSF_fnc_getMissionVar;
private _odaSave = createHashMap;
{
    private _slotId = _x;
    private _slotMap = _y;
    private _stripped = createHashMap;
    {
        if (_x != OSF_ODA_UNIT_REF) then {
            _stripped set [_x, _y];
        };
    } forEach _slotMap;
    _odaSave set [_slotId, _stripped];
} forEach _odaReg;
_save set ["odaRoster", _odaSave];

// ---- Upgrades ----
_save set ["upgrades", [OSF_KEY_UPGRADE_STATE, createHashMap] call OSF_fnc_getMissionVar];

// ---- Player loadout ----
_save set ["playerLoadout", getUnitLoadout player];

// ---- Write to profile ----
[OSF_PROFILE_SAVE_DATA, _save] call OSF_fnc_setProfileVar;
[OSF_PROFILE_SAVE_EXISTS, true] call OSF_fnc_setProfileVar;
saveProfileNamespace;

["save", format ["Game saved (%1). Version %2. Sectors: %3, ODA: %4.",
    _source, OSF_SAVE_VERSION, count _sectorSave, count _odaSave], OSF_LOG_INFO] call OSF_fnc_log;

hint "Game saved.";
