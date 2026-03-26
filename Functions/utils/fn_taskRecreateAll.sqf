// ============================================================
// OSF_fnc_taskRecreateAll
// Recreates all tracked BIS tasks from saved state on mission load.
// BIS tasks are runtime-only and don't persist — this function
// rebuilds them from the OSF_taskStates hashmap after load.
//
// Called on the "continue" path after save has been restored.
// All tasks are recreated silently (no notifications).
//
// Params: none
// Returns: number of tasks recreated
// Usage:  [] call OSF_fnc_taskRecreateAll;
// ============================================================

#include "..\..\scripts\constants.hpp"

private _states = [OSF_KEY_TASK_STATES, createHashMap] call OSF_fnc_getMissionVar;
private _registry = [OSF_KEY_TASK_REGISTRY, createHashMap] call OSF_fnc_getMissionVar;
private _count = 0;

{
    private _taskId = _x;
    private _savedState = _y;
    private _def = _registry getOrDefault [_taskId, createHashMap];

    if (count keys _def == 0) then {
        ["task", format ["taskRecreateAll — '%1' not in registry, skipping.", _taskId], OSF_LOG_WARN] call OSF_fnc_log;
    } else {
        private _desc = [
            _def getOrDefault ["description", ""],
            _def getOrDefault ["title", ""],
            _def getOrDefault ["tag", ""]
        ];

        [
            true,
            [_taskId],
            _desc,
            nil,
            _savedState,
            _def getOrDefault ["priority", -1],
            false,
            _def getOrDefault ["type", "default"]
        ] call BIS_fnc_taskCreate;

        _count = _count + 1;
    };
} forEach _states;

["task", format ["Recreated %1 task(s) from save.", _count], OSF_LOG_INFO] call OSF_fnc_log;

_count
