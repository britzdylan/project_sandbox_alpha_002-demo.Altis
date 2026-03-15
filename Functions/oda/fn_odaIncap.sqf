// ============================================================
// OSF_fnc_odaIncap
// Called from the handleDamage EH when a unit takes fatal damage.
// Sets the slot to INCAP, plays the downed animation, freezes
// damage, adds a player revive action, and spawns the watcher.
//
// params:
//   _unit (OBJECT) — the downed ODA unit
//
// Returns: nothing
// Usage: [_unit] call OSF_fnc_odaIncap;
// ============================================================
#include "..\..\scripts\constants.hpp"

params ["_unit"];

private _slotId = _unit getVariable [OSF_ODA_SLOT_ID, ""];
if (_slotId == "") exitWith {
	["odaIncap", "ERROR: downed unit has no slot ID variable"] call OSF_fnc_log;
};

private _slot = [OSF_KEY_ODA_ROSTER, _slotId] call OSF_fnc_getState;
if (isNil "_slot") exitWith {};

// Update slot state
private _targetTime = time + OSF_INCAP_DURATION;
_slot set [OSF_ODA_STATUS,            OSF_ODA_STATUS_INCAP];
_slot set [OSF_ODA_INCAPACITATED_TIMER, _targetTime];

// Downed animation and damage freeze
_unit setUnconscious true;
_unit allowDamage false;

// Revive hold-action — visible to player within 5m with a medkit.
// Hold duration matches OSF_REVIVE_DURATION_PLAYER; fn_odaRevive skips its own sleep (_skipSleep = true).
private _actionId = [
	_unit,
	"<t color='#ff8800'>Revive (field aid)</t>",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa",
	"player distance _target < 5 && { ""Medikit"" in items player }",
	"player distance _target < 5 && { ""Medikit"" in items player }",
	{},
	{},
	{ [_target, false, true] spawn OSF_fnc_odaRevive; },
	{},
	[],
	OSF_REVIVE_DURATION_PLAYER,
	1.5,
	true,
	true
] call BIS_fnc_holdActionAdd;
_unit setVariable [OSF_REVIVE_ACTION_ID, _actionId];

[_slotId, _targetTime] spawn OSF_fnc_odaIncapWatcher;

["odaIncap", format ["Slot '%1' incapacitated — KIA in %2s", _slotId, OSF_INCAP_DURATION]] call OSF_fnc_log;
