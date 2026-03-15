// ============================================================
// OSF_fnc_odaApplyLoadout
// Updates a slot's loadout field and, if the unit is spawned
// and local, immediately applies the loadout script to the unit.
//
// params:
//   _slotId    (STRING) — key in OSF_odaRoster
//   _loadoutId (STRING) — loadout script name (without path/extension)
//                         must match a file in scripts\loadouts\
//
// Returns: nothing
// Usage:   [_slotId, "oda_nato_marksmen"] call OSF_fnc_odaApplyLoadout;
// ============================================================
#include "..\..\scripts\constants.hpp"

params ["_slotId", "_loadoutId"];

private _slot = [OSF_KEY_ODA_ROSTER, _slotId] call OSF_fnc_getState;
if (isNil "_slot") exitWith {};

// Update the data field — hashmap is a reference type, no setMissionVar needed
_slot set [OSF_ODA_LOADOUT, _loadoutId];

// Apply to unit if spawned and local
private _unit = _slot getOrDefault [OSF_ODA_UNIT_REF, objNull];
if (!isNull _unit && {local _unit}) then {
	[_unit] call compile preProcessFileLineNumbers ("scripts\loadouts\" + _loadoutId + ".sqf");
};

["odaApplyLoadout", format ["Applied '%1' to slot '%2'", _loadoutId, _slotId]] call OSF_fnc_log;
