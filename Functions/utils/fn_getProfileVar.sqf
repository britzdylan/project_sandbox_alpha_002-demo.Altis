// ============================================================
// OSF_fnc_getProfileVar
// Gets a variable from profileNamespace with a required default fallback.
// Warns to RPT if the key was missing (useful for catching save/load gaps).
//
// Params: [key (string), default (any)]
// Returns: stored value, or default if key not set
// Usage:  _exists = ["OSF_saveExists", false] call OSF_fnc_getProfileVar;
// ============================================================

params ["_key", "_default"];

private _sentinel = "__OSF_MISSING__";
private _value = profileNamespace getVariable [_key, _sentinel];

if (_value isEqualTo _sentinel) then {
    ["getProfileVar", format ["key '%1' not in profile, returning default: %2", _key, _default]] call OSF_fnc_log;
    _default
} else {
    _value
};
