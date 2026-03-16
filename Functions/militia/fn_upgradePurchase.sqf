// ============================================================
// OSF_fnc_upgradePurchase
// Executes a node purchase: validates, deducts CP, sets boolean.
//
// params:
//   _nodeId (string) — node identifier from upgradeData.sqf
// returns:
//   bool — true on success, false if purchase was blocked
//
// Usage:
//   private _ok = ["upgrade_cap_technicals"] call OSF_fnc_upgradePurchase;
// ============================================================

#include "..\..\scripts\constants.hpp"

params ["_nodeId"];

private _check = [_nodeId] call OSF_fnc_upgradeCanPurchase;
if !(_check select 0) exitWith {
    ["upgradePurchase", format ["Blocked (%1): %2", _nodeId, _check select 1]] call OSF_fnc_log;
    false
};

// Resolve cost from node def index
private _nodeDef     = ([OSF_KEY_UPGRADE_DEFS] call OSF_fnc_getMissionVar) get _nodeId;
private _cost        = _nodeDef select 3;
private _displayName = _nodeDef select 1;

// Deduct cost
private _currentCP = [OSF_KEY_CP_POINTS] call OSF_fnc_getMissionVar;
[OSF_KEY_CP_POINTS, _currentCP - _cost] call OSF_fnc_setMissionVar;

// Flip boolean
private _upgradeMap = [OSF_KEY_UPGRADE_STATE] call OSF_fnc_getMissionVar;
_upgradeMap set [_nodeId, true];
[OSF_KEY_UPGRADE_STATE, _upgradeMap] call OSF_fnc_setMissionVar;

["upgradePurchase", format ["Purchased: %1 (cost %2 CP). Remaining CP: %3.", _displayName, _cost, _currentCP - _cost]] call OSF_fnc_log;

true
