// ============================================================
// OSF_fnc_taskCreate
// Creates a BIS task using the centralized task registry.
// Tracks task state in OSF_taskStates for save/load persistence.
//
// Params:
//   0: taskId            (string)  — must exist in OSF_taskRegistry
//   1: destination       (any)     — position, object, or nil
//   2: initialState      (string)  — "CREATED", "ASSIGNED", etc.
//   3: showNotification  (bool)    — optional, default true
//
// Returns: taskId string on success, "" on failure
// Usage:  ["task_establish_toc", _tocPos, "CREATED"] call OSF_fnc_taskCreate;
// ============================================================

#include "..\..\scripts\constants.hpp"

params ["_taskId", ["_destination", nil], ["_initialState", "CREATED"], ["_showNotification", true]];

// Look up definition
private _registry = [OSF_KEY_TASK_REGISTRY, createHashMap] call OSF_fnc_getMissionVar;
private _def = _registry getOrDefault [_taskId, createHashMap];

if (count keys _def == 0) exitWith {
    ["task", format ["taskCreate FAILED — '%1' not found in task registry.", _taskId], OSF_LOG_ERROR] call OSF_fnc_log;
    ""
};

// Build BIS description array
private _desc = [
    _def getOrDefault ["description", ""],
    _def getOrDefault ["title", ""],
    _def getOrDefault ["tag", ""]
];

// Create via BIS framework
[
    true,
    [_taskId],
    _desc,
    _destination,
    _initialState,
    _def getOrDefault ["priority", -1],
    _showNotification,
    _def getOrDefault ["type", "default"]
] call BIS_fnc_taskCreate;

// Track state
private _states = [OSF_KEY_TASK_STATES, createHashMap] call OSF_fnc_getMissionVar;
_states set [_taskId, _initialState];
[OSF_KEY_TASK_STATES, _states] call OSF_fnc_setMissionVar;

["task", format ["Task created: %1 [%2]", _taskId, _initialState], OSF_LOG_INFO] call OSF_fnc_log;

_taskId
