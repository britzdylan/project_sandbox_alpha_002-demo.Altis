// ============================================================
// OSF_fnc_setProfileVar
// Sets a variable on profileNamespace (persists across sessions).
// Always prefixes key with "OSF_" if not already present, to avoid
// polluting the player's profile with bare key names.
//
// Params: [key (string), value (any), log (bool, optional — default false)]
// Returns: nothing
// Usage:  ["OSF_saveExists", true] call OSF_fnc_setProfileVar;
// ============================================================

params ["_key", "_value", ["_log", false]];

profileNamespace setVariable [_key, _value];

if (_log) then {
    ["setProfileVar", format ["%1 = %2", _key, _value]] call OSF_fnc_log;
};
