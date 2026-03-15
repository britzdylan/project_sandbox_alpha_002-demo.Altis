// ============================================================
// OSF_fnc_odaReplacementWatcher
// Scheduled: sleeps until the replacement timer expires, then
// returns the slot to INACTIVE so it can be redeployed.
// One instance spawned per KIA event.
// 
// params:
//   _slotId     (STRING) — key in OSF_odaRoster
//   _targetTime (NUMBER) — mission time at which slot becomes available
// 
// Returns: nothing
// Usage: [_slotId, _targetTime] spawn OSF_fnc_odaReplacementWatcher;
// ============================================================
#include "..\..\scripts\constants.hpp"

params ["_slotId", "_targetTime"];

waitUntil {
	time >= _targetTime
};

private _slot = [OSF_KEY_ODA_ROSTER, _slotId] call OSF_fnc_getState;
if (isNil "_slot") exitWith {};

// Only promote if still KIA — a manual override may have changed the status
if ((_slot get OSF_ODA_STATUS) != OSF_ODA_STATUS_KIA) exitWith {};

_slot set [OSF_ODA_STATUS, OSF_ODA_STATUS_INACTIVE];
_slot set [OSF_ODA_REPLACEMENT_TIMER, -1];

["odaReplacementWatcher", format ["Slot '%1' replacement complete — STANDBY", _slotId]] call OSF_fnc_log;