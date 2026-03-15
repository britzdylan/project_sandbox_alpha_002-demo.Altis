// ============================================================
// OSF_fnc_odaIncapWatcher
// Scheduled loop spawned by fn_odaIncap. Every 5 seconds:
//   1. Checks if the slot was already revived (exit cleanly)
//   2. Checks if a medic is within 15m — triggers auto-revive
//   3. Checks if the incap timer has expired — triggers KIA
// 
// params:
//   _slotId     (STRING) — key in OSF_odaRoster
//   _targetTime (NUMBER) — mission time at which the unit goes KIA
// 
// Returns: nothing
// Usage: [_slotId, _targetTime] spawn OSF_fnc_odaIncapWatcher;
// ============================================================
#include "..\..\scripts\constants.hpp"

params ["_slotId", "_targetTime"];

waitUntil {
	sleep 5;

	private _slot = [OSF_KEY_ODA_ROSTER, _slotId] call OSF_fnc_getState;
	// Slot gone — nothing to do
	if (isNil "_slot") exitWith {
		true
	};

	// Already resolved (revived or manually changed)
	if ((_slot get OSF_ODA_STATUS) != OSF_ODA_STATUS_INCAP) exitWith {
		true
	};

	private _unit = _slot getOrDefault [OSF_ODA_UNIT_REF, objNull];
	if (isNull _unit) exitWith {
		true
	};

	// --- Medic proximity check ---
	private _medic = objNull;
	{
		if (_x getVariable [OSF_ODA_MOS, ""] == "18D" && (_x distance _unit) <= 25 && "Medikit" in items _x && !(_x getVariable OSF_ODA_INCAPACITATED) && !(_x getVariable [OSF_REVIVE_IN_PROGRESS, false])) exitWith {
			_medic = _x;
		};
	} forEach (units group player);

	if (!isNull _medic && !(_unit getVariable [OSF_REVIVE_IN_PROGRESS, false])) then {
		["odaIncapWatcher", format ["Slot '%1' — medic nearby, auto-reviving", _slotId]] call OSF_fnc_log;
		_unit setVariable [OSF_REVIVE_IN_PROGRESS, true];
		_medic setVariable [OSF_REVIVE_IN_PROGRESS, true];
		[_unit, true] spawn OSF_fnc_odaRevive;
	};

	// --- Timer expiry → KIA ---
	if (time >= _targetTime) exitWith {
		["odaIncapWatcher", format ["Slot '%1' — incap timer expired, going KIA", _slotId]] call OSF_fnc_log;
		_unit setVariable [OSF_ODA_INCAPACITATED, false];
		_unit allowDamage true;
		_unit setUnconscious false;
		_unit setDamage 1.1;

		private _actionId = _unit getVariable OSF_REVIVE_ACTION_ID;
		[_unit, _actionId] call BIS_fnc_holdActionRemove;
		true
	};

	false
};