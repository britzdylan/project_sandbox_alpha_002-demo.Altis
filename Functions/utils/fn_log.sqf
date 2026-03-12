// ============================================================
// OSF_fnc_log
// Writes a message to the RPT log. When OSF_debug is true,
// also echoes to systemChat for in-game visibility.
//
// Params: [tag (string), message (string)]
// Returns: nothing
// Usage:  ["initGameState", "sector loaded"] call OSF_fnc_log;
//         ["setSector",     format ["status -> %1", _value]] call OSF_fnc_log;
// ============================================================

params ["_tag", "_message"];

private _line = format ["[OSF][%1] %2", _tag, _message];

diag_log _line;

if (missionNamespace getVariable ["OSF_debug", false]) then {
    systemChat _line;
};
