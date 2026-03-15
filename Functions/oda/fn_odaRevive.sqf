// ============================================================
// OSF_fnc_odaRevive
// Performs the revive sequence: waits out the revive duration,
// restores the unit to active duty, clears incap state.
// Must run in a scheduled environment (sleeps during revive).
// 
// params:
//   _unit    (OBJECT) — the downed ODA unit
//   _isMedic (BOOL)   — true = medic auto-revive (shorter duration)
// 
// Returns: nothing
// Usage: [_unit, false] spawn OSF_fnc_odaRevive;  // player revive
//        [_unit, true]  spawn OSF_fnc_odaRevive;  // medic revive
// ============================================================
#include "..\..\scripts\constants.hpp"

params ["_unit", "_isMedic", ["_skipSleep", false]];

private _slotId = _unit getVariable [OSF_ODA_SLOT_ID, ""];
if (_slotId == "") exitWith {
	["odaRevive", "ERROR: unit has no slot ID variable"] call OSF_fnc_log;
};

private _slot = [OSF_KEY_ODA_ROSTER, _slotId] call OSF_fnc_getState;
if (isNil "_slot") exitWith {};

// Guard: only proceed if still incapacitated (race condition safety)
if ((_slot get OSF_ODA_STATUS) != OSF_ODA_STATUS_INCAP) exitWith {};

// Revive animation on the person performing the aid
private _reviver = objNull;
if (_isMedic) then {
	{
		if (_x getVariable [OSF_ODA_MOS, ""] == "18D") exitWith {
			_reviver = _x;
		};
	} forEach (units group player);
};

if (!isNull _reviver && _isMedic) then {
	_reviver doMove (position _unit);
	waitUntil {
		_reviver distance _unit < 2;
	};
	_reviver setUnitPos "MIDDLE";
	_reviver setDir (getDir _unit);
	_reviver lookAt _unit;
	// Play throw animation then spawn smoke at the downed unit's position
	sleep 0.4;
	"SmokeShell" createVehicle (getPos _unit);
};

private _duration = if (_isMedic) then {
	OSF_REVIVE_DURATION_MEDIC
} else {
	OSF_REVIVE_DURATION_PLAYER
};
if (!_skipSleep) then { sleep _duration; };
if (!isNull _reviver && _isMedic) then {
	_reviver enableAI "ALL";
	_reviver switchMove "";
	_reviver setUnitPos "AUTO";
	_reviver setVariable [OSF_REVIVE_IN_PROGRESS, false];
};
// Re-check status — timer may have expired during the sleep (race condition)
if ((_slot get OSF_ODA_STATUS) != OSF_ODA_STATUS_INCAP) exitWith {
	_unit setVariable [OSF_REVIVE_IN_PROGRESS, false];
	["odaRevive", format ["Slot '%1' — revive aborted, status changed during sleep", _slotId]] call OSF_fnc_log;
};

// Restore unit
_unit setUnconscious false;
_unit allowDamage true;
_unit setDamage 0.5;
_unit setVariable [OSF_ODA_INCAPACITATED, false];

// Remove revive action
_unit removeAction (_unit getVariable ["OSF_reviveActionId", -1]);

// Update slot
_slot set [OSF_ODA_STATUS, OSF_ODA_STATUS_ACTIVE];
_slot set [OSF_ODA_INCAPACITATED_TIMER, -1];

// Reviver performs the heal action — plays animation and restores hit points
if (!isNull _reviver) then {
	_reviver action ["HealSoldier", _unit];
};
private _reviverLabel = if (_isMedic) then {
	"medic"
} else {
	"player"
};
_unit setVariable ["OSF_reviveInProgress", false];
["odaRevive", format ["Slot '%1' revived by %2", _slotId, _reviverLabel]] call OSF_fnc_log;