// ============================================================
// OSF_fnc_upgradeHasNode
// Returns whether a specific upgrade node has been purchased.
// This is the primary query API for all other systems.
//
// params:
//   _nodeId (string) — node identifier from upgradeData.sqf
// returns:
//   bool — true if purchased, false if locked or unknown
//
// Usage:
//   if (["upgrade_cap_technicals"] call OSF_fnc_upgradeHasNode) then { ... };
// ============================================================

#include "..\..\scripts\constants.hpp"

params ["_nodeId"];

private _upgradeMap = [OSF_KEY_UPGRADE_STATE] call OSF_fnc_getMissionVar;

if (isNil "_upgradeMap") exitWith {
    ["upgradeHasNode", format ["WARNING — upgrade state not initialised (queried: %1)", _nodeId]] call OSF_fnc_log;
    false
};

private _result = _upgradeMap getOrDefault [_nodeId, false];
_result
