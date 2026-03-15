// ============================================================
// OSF_fnc_odaDismiss
// Removes an ODA unit from the field and returns the slot to standby.
// Deletes the AI object; clears unitRef. Status → INACTIVE.
//
// params:
//   _slotId (STRING) — key in OSF_odaRoster
//
// Returns: nothing
// Usage:   [_slotId] call OSF_fnc_odaDismiss;
// ============================================================
#include "..\..\scripts\constants.hpp"

params ["_slotId"];

private _slot = [OSF_KEY_ODA_ROSTER, _slotId] call OSF_fnc_getState;
if (isNil "_slot") exitWith {};

private _unit = _slot getOrDefault [OSF_ODA_UNIT_REF, objNull];
if (!isNull _unit) then {
	[_unit] joinSilent grpNull;
	deleteVehicle _unit;
};

_slot set [OSF_ODA_STATUS,   OSF_ODA_STATUS_INACTIVE];
_slot set [OSF_ODA_IN_SQUAD, false];
_slot set [OSF_ODA_UNIT_REF, objNull];

["odaDismiss", format ["Dismissed slot '%1'", _slotId]] call OSF_fnc_log;
