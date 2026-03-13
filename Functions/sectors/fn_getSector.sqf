// ============================================================
// OSF_fnc_getSector
// Returns a named field from a sector's runtime state hashmap.
// 
// params: [sectorID (string), fieldName (string)]
// Returns: field value, or nil if sector/field not found
// Usage:  _status = ["sector_tutorial", "status"] call OSF_fnc_getSector;
//         _pos    = ["sector_tutorial", "poiPos"] call OSF_fnc_getSector;
// ============================================================

#include "..\..\scripts\constants.hpp"

params ["_sectorID", "_fieldName"];

private _registry = [OSF_KEY_SECTOR_STATE, createHashMap] call OSF_fnc_getMissionVar;
private _sectorMap = _registry getOrDefault [_sectorID, nil];

if (isNil "_sectorMap") exitWith {
	["getSector", format ["unknown sectorID '%1'", _sectorID]] call OSF_fnc_log;
	nil
};

_sectorMap getOrDefault [_fieldName, nil]