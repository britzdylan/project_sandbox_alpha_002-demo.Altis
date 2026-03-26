// ============================================================
// OSF_fnc_taskSetState
// Sets a BIS task state and updates the runtime tracking hashmap.
// Fires OSF_EVT_QUEST_STATE_CHANGED CBA event.
//
// Valid states: "CREATED", "ASSIGNED", "SUCCEEDED", "FAILED", "CANCELED"
// Note: CANCELED is spelled with one L (Arma convention).
//
// Params:
//   0: taskId            (string)  — task to update
//   1: newState          (string)  — target state
//   2: showNotification  (bool)    — optional, default true
//
// Returns: nothing
// Usage:  ["task_establish_toc", "SUCCEEDED"] call OSF_fnc_taskSetState;
// ============================================================

#include "..\..\scripts\constants.hpp"

params ["_taskId", "_newState", ["_showNotification", true]];

// Update BIS task
[_taskId, _newState, _showNotification] call BIS_fnc_taskSetState;

// Update runtime tracking
private _states = [OSF_KEY_TASK_STATES, createHashMap] call OSF_fnc_getMissionVar;
_states set [_taskId, _newState];
[OSF_KEY_TASK_STATES, _states] call OSF_fnc_setMissionVar;

// Fire CBA event
[OSF_EVT_QUEST_STATE_CHANGED, [_taskId, _newState]] call CBA_fnc_localEvent;

["task", format ["Task state: %1 → %2", _taskId, _newState], OSF_LOG_INFO] call OSF_fnc_log;
