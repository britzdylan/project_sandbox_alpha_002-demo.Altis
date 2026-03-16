// ============================================================
// OSF_fnc_upgradeCanPurchase
// Validates whether a node can be purchased right now.
// Checks: not already acquired, sufficient CP, all prereqs met.
//
// params:
//   _nodeId (string) — node identifier from upgradeData.sqf
// returns:
//   [bool, string] — [canPurchase, reasonIfNot]
//
// Usage:
//   private _check = ["upgrade_cap_technicals"] call OSF_fnc_upgradeCanPurchase;
//   if (_check select 0) then { ... } else { hint (_check select 1); };
// ============================================================

#include "..\..\scripts\constants.hpp"

params ["_nodeId"];

private _defsIndex = [OSF_KEY_UPGRADE_DEFS] call OSF_fnc_getMissionVar;

private _nodeDef = _defsIndex getOrDefault [_nodeId, nil];
if (isNil "_nodeDef") exitWith {
    ["upgradeCanPurchase", format ["WARNING — unknown nodeId: %1", _nodeId]] call OSF_fnc_log;
    [false, format ["Unknown upgrade node: %1", _nodeId]]
};

private _displayName = _nodeDef select 1;
private _cost        = _nodeDef select 3;
private _prereqs     = _nodeDef select 4;

// Already purchased?
if ([_nodeId] call OSF_fnc_upgradeHasNode) exitWith {
    [false, format ["%1 already acquired.", _displayName]]
};

// Sufficient CP?
private _cpAvailable = [OSF_KEY_CP_POINTS] call OSF_fnc_getMissionVar;
if (_cpAvailable < _cost) exitWith {
    [false, format ["Insufficient command points. Need %1, have %2.", _cost, _cpAvailable]]
};

// All prerequisites met — first failure wins
private _failReason = "";
{
    if !([_x] call OSF_fnc_upgradeHasNode) then {
        if (_failReason == "") then {
            // Look up prereq displayName via index (select 1).
        // Fallback [_x, _x] means: if nodeId is missing from index, select 1 returns the raw ID instead of erroring.
        private _prereqName = ((_defsIndex getOrDefault [_x, [_x, _x]]) select 1);
            _failReason = format ["Missing prerequisite: %1", _prereqName];
        };
    };
} forEach _prereqs;

if (_failReason != "") exitWith { [false, _failReason] };

[true, ""]
