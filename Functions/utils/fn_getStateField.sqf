// ============================================================
// OSF_fnc_getStateField
// Returns a named field from an item's runtime state hashmap.
// 
// params: [hashMap (hashMap), ID (string), fieldName (string)]
// Returns: field value, or nil if ID/field not found
// Usage:  _status = [_hashMap, "sector_tutorial", "status"] call OSF_fnc_getStateField;
//         _pos    = [_hashMap, "sector_tutorial", "poiPos"] call OSF_fnc_getStateField;
// ============================================================

params ["_hashMap", "_ID", "_fieldName"];

private _registry = [_hashMap, nil] call OSF_fnc_getMissionVar;

if (isNil "_registry") exitWith {
	["getStateField", format ["unknown _hashMap '%1'", _hashMap]] call OSF_fnc_log;
	nil
};

private _hashItem = _registry getOrDefault [_ID, nil];

if (isNil "_hashItem") exitWith {
	["getStateField", format ["unknown _ID '%1'", _ID]] call OSF_fnc_log;
	nil
};

_hashItem getOrDefault [_fieldName, nil];