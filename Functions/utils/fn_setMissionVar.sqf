// ============================================================
// OSF_fnc_setMissionVar
// Sets a variable on missionNamespace with optional debug logging.
//
// Params: [key (string), value (any), log (bool, optional — default false)]
// Returns: nothing
// Usage:  ["OSF_campaignPhase", 2] call OSF_fnc_setMissionVar;
//         ["OSF_campaignPhase", 2, true] call OSF_fnc_setMissionVar;
// ============================================================

params ["_key", "_value", ["_log", false]];

missionNamespace setVariable [_key, _value];

if (_log) then {
    ["setMissionVar", format ["%1 = %2", _key, _value]] call OSF_fnc_log;
};
