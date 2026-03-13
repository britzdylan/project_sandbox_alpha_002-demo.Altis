// ============================================================
// OSF_fnc_getStateKeys
// Returns all IDs registered in a state hashmap.
//
// params: [registryKey (string)]
// Returns: array of ID strings, or [] if registry is empty/missing
// Usage:  _ids = [OSF_KEY_SECTOR_STATE] call OSF_fnc_getStateKeys;
//         _ids = [OSF_KEY_ODA_ROSTER]   call OSF_fnc_getStateKeys;
// ============================================================
#include "..\..\scripts\constants.hpp"

params ["_registryKey"];

private _registry = [_registryKey, createHashMap] call OSF_fnc_getMissionVar;
keys _registry
