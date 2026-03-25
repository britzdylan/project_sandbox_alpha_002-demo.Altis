// ============================================================
// OSF_fnc_getMissionVar
// Gets a variable from missionNamespace with a required default fallback.
// Warns to RPT if the key was missing (i.e. fallback was used).
// 
// params: [key (string), default (any)]
// Returns: stored value, or default if key not set
// Usage:  _phase = ["OSF_campaignPhase", 1] call OSF_fnc_getMissionVar;
// ============================================================

params ["_key", ["_default", nil]];

private _value = missionNamespace getVariable _key;

if (isNil "_value") then {
	if (isNil "_default") then {
		["getMissionVar", format ["FATAL: '%1' not in missionNamespace", _key], 1] call OSF_fnc_log;
		nil
	} else {
		["getMissionVar", format ["WARN: '%1' not in missionNamespace, using default: %2", _key, _default], 2] call OSF_fnc_log;
		_default
	};
} else {
	_value
};