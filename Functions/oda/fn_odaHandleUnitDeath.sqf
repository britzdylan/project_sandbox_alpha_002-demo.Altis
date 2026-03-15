// ============================================================
// OSF_fnc_odaHandleUnitDeath
// Fired by the unit's "killed" event handler.
// Marks the slot as KIA, clears inSquad and unitRef.
//
// params:
//   _args (ARRAY) — [unit, killer, instigator] from the killed EH
//
// Returns: nothing
// Usage: called internally via addEventHandler ["killed", { [_this] call OSF_fnc_odaHandleUnitDeath }]
// ============================================================
#include "..\..\scripts\constants.hpp"

params ["_args"];
private _unit = _args select 0;

private _slotId = _unit getVariable [OSF_ODA_SLOT_ID, ""];
if (_slotId == "") exitWith {
	["odaHandleUnitDeath", "ERROR: killed unit has no slot ID variable"] call OSF_fnc_log;
};

private _slot = [OSF_KEY_ODA_ROSTER, _slotId] call OSF_fnc_getState;
if (isNil "_slot") exitWith {};

// Guard: if still flagged incapacitated the watcher hasn't cleared it yet — ignore
if (_unit getVariable [OSF_ODA_INCAPACITATED, false]) exitWith {
	["odaHandleUnitDeath", format ["Slot '%1' — ignoring killed EH, unit is incapacitated", _slotId]] call OSF_fnc_log;
};

_slot set [OSF_ODA_STATUS,            OSF_ODA_STATUS_KIA];
_slot set [OSF_ODA_IN_SQUAD,          false];
_slot set [OSF_ODA_UNIT_REF,          objNull];

private _targetTime = time + OSF_REPLACEMENT_DURATION;
_slot set [OSF_ODA_REPLACEMENT_TIMER, _targetTime];

[_slotId, _targetTime] spawn OSF_fnc_odaReplacementWatcher;

["odaHandleUnitDeath", format ["Slot '%1' KIA — replacement in %2s", _slotId, OSF_REPLACEMENT_DURATION]] call OSF_fnc_log;
