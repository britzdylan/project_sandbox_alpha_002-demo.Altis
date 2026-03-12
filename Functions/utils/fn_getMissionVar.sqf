// ============================================================
// OSF_fnc_getMissionVar
// Gets a variable from missionNamespace with a required default fallback.
// Warns to RPT if the key was missing (i.e. fallback was used).
//
// Params: [key (string), default (any)]
// Returns: stored value, or default if key not set
// Usage:  _phase = ["OSF_campaignPhase", 1] call OSF_fnc_getMissionVar;
// ============================================================

params ["_key", "_default"];

private _sentinel = "__OSF_MISSING__";
private _value = missionNamespace getVariable [_key, _sentinel];

if (_value isEqualTo _sentinel) then {
    ["getMissionVar", format ["key '%1' not set, returning default: %2", _key, _default]] call OSF_fnc_log;
    _default
} else {
    _value
};
