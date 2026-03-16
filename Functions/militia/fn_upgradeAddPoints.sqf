// ============================================================
// OSF_fnc_upgradeAddPoints
// Adds command points to the available pool.
// Called by sector liberation and side objective completion.
//
// params:
//   _amount (number) — CP to add (must be positive)
// returns:
//   number — new CP total
//
// Usage:
//   [4] call OSF_fnc_upgradeAddPoints;
// ============================================================

#include "..\..\scripts\constants.hpp"

params ["_amount"];

if (_amount <= 0) exitWith {
    ["upgradeAddPoints", format ["WARNING — invalid amount: %1", _amount]] call OSF_fnc_log;
    [OSF_KEY_CP_POINTS] call OSF_fnc_getMissionVar
};

private _current = [OSF_KEY_CP_POINTS] call OSF_fnc_getMissionVar;
private _newTotal = _current + _amount;
[OSF_KEY_CP_POINTS, _newTotal] call OSF_fnc_setMissionVar;

["upgradeAddPoints", format ["+%1 CP awarded. Total: %2.", _amount, _newTotal]] call OSF_fnc_log;

_newTotal
