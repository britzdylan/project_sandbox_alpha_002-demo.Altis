// ============================================================
// OSF_fnc_log
// Writes a message to the RPT log with per-domain verbosity control.
// When OSF_debug is true and the message level passes the domain's
// verbosity threshold, also echoes to systemChat.
//
// Params: [tag (string), message (string), level (number, optional — default 3/INFO)]
// Returns: nothing
//
// Levels: 1=ERROR, 2=WARN, 3=INFO, 4=VERBOSE  (see constants.hpp)
//
// Usage:  ["initGameState", "sector loaded"] call OSF_fnc_log;
//         ["oda", "spawned slot 3", 4] call OSF_fnc_log;           // verbose
//         ["sectors", "FATAL: missing boundary", 1] call OSF_fnc_log; // error
// ============================================================

#include "..\..\scripts\constants.hpp"

params ["_tag", "_message", ["_level", OSF_LOG_INFO]];

// Master kill switch — if debug is off, only errors go to RPT
private _debug = missionNamespace getVariable ["OSF_debug", false];

if (!_debug && _level > OSF_LOG_ERROR) exitWith {};

// Per-domain verbosity check
private _verbMap = missionNamespace getVariable ["OSF_logVerbosity", createHashMap];
private _threshold = _verbMap getOrDefault [_tag, OSF_LOG_INFO];

if (_level > _threshold) exitWith {};

// Format and output
private _levelTag = switch (_level) do {
    case OSF_LOG_ERROR:   { "ERR" };
    case OSF_LOG_WARN:    { "WRN" };
    case OSF_LOG_VERBOSE: { "VRB" };
    default               { "INF" };
};

private _line = format ["[OSF][%1][%2] %3", _tag, _levelTag, _message];

diag_log _line;

if (_debug) then {
    systemChat _line;
};
