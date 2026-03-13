// ============================================================
// OSF_fnc_getStateValues
// Returns all item hashmaps registered in a state registry.
//
// params: [registryKey (string)]
// Returns: array of hashmaps, or [] if registry is empty/missing
// Usage:  _maps = [OSF_KEY_SECTOR_STATE] call OSF_fnc_getStateValues;
//         _maps = [OSF_KEY_ODA_ROSTER]   call OSF_fnc_getStateValues;
// ============================================================
#include "..\..\scripts\constants.hpp"

params ["_registryKey"];

private _registry = [_registryKey, createHashMap] call OSF_fnc_getMissionVar;
values _registry
