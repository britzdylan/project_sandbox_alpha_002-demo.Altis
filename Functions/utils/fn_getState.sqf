// ============================================================
// OSF_fnc_getState
// Returns runtime state hashmap item.
// 
// params: [hashMap (hashMap), ID (string), fieldName (string)]
// Returns: field value, or nil if ID/field not found
// Usage:  _status = [_hashMap, "sector_tutorial", "status"] call OSF_fnc_getState;
//         _pos    = [_hashMap, "sector_tutorial", "poiPos"] call OSF_fnc_getState;
// ============================================================

params ["_hashMap", "_ID"];

private _registry = [_hashMap, nil] call OSF_fnc_getMissionVar;

if (isNil "_registry") exitWith {
	["getState", format ["unknown _hashMap '%1'", _hashMap]] call OSF_fnc_log;
	nil
};

private _hashItem = _registry getOrDefault [_ID, nil];

if (isNil "_hashItem") then {
    ["getState", format ["FATAL: '%1' not in '%2'", _hashItem, _registry]] call OSF_fnc_log;
};

_hashItem;