// ============================================================
// OSF_fnc_odaSpawn
// Spawns a single ODA slot into the world, assigns a random
// unused identity, joins the player's group, and updates the
// roster hashmap.
// 
// params:
//   _slotId   (STRING) — key in OSF_odaRoster
//   _spawnPos (ARRAY, optional) — world position to spawn at.
//             if omitted or empty, spawns near the player.
// 
// Returns: the created unit object, or objNull on failure
// Usage:   [_slotId] call OSF_fnc_odaSpawn;
//          [_slotId, getPos myMarker] call OSF_fnc_odaSpawn;
// ============================================================
#include "..\..\scripts\constants.hpp"

params ["_slotId", ["_spawnPos", []]];

// --- get slot from roster ---
private _roster = [OSF_KEY_ODA_ROSTER] call OSF_fnc_getMissionVar;
private _slot = [OSF_KEY_ODA_ROSTER, _slotId] call OSF_fnc_getState;

if (isNil "_slot") exitWith {
	["odaSpawn", format ["ERROR: slot '%1' not found in roster", _slotId]] call OSF_fnc_log;
	objNull
};

// --- Pick a random unused identity from the 24-identity pool ---
private _usedIdentities = [];
{
	private _ident = _y getOrDefault [OSF_ODA_IDENTITY_CLASS, ""];
	if (_ident != "") then {
		_usedIdentities pushBack _ident;
	};
} forEach _roster;

private _available = [];
for "_i" from 1 to 24 do {
	private _id = (if (_i < 10) then {
		"OSF_ODA_0"
	} else {
		"OSF_ODA_"
	}) + str _i;
	if !(_id in _usedIdentities) then {
		_available pushBack _id;
	};
};

// All 24 in use (shouldn't happen with 11 slots) — allow reuse
if (count _available == 0) then {
	for "_i" from 1 to 24 do {
		_available pushBack ((if (_i < 10) then {
			"OSF_ODA_0"
		} else {
			"OSF_ODA_"
		}) + str _i);
	};
};

private _identityClass = selectRandom _available;

// --- Resolve spawn position ---
if (count _spawnPos == 0) then {
	_spawnPos = getPos player;
};

// --- Create unit then join player's group ---
private _unitClass = _slot get OSF_ODA_UNIT_CLASS;
private _rank = _slot get OSF_ODA_RANK;
private _loadoutId = _slot get OSF_ODA_LOADOUT;
private _unit = group player createUnit [_unitClass, _spawnPos, [], 20, "NONE"];

_unit setRank _rank;
_unit setSkill 0.75;
[_unit] joinSilent (group player);

// --- apply identity and display name ---
_unit setIdentity _identityClass;
_unit setVariable [OSF_ODA_SLOT_ID, _slotId];
_unit addEventHandler ["killed", {
	[_this] call OSF_fnc_odaHandleUnitDeath
}];
// --- Update roster ---
_slot set [OSF_ODA_STATUS, OSF_ODA_STATUS_ACTIVE];
_slot set [OSF_ODA_IN_SQUAD, true];
_slot set [OSF_ODA_IDENTITY_CLASS, _identityClass];
_slot set [OSF_ODA_UNIT_REF, _unit];

// apply loadout
[_slotId, _loadoutId] call OSF_fnc_odaApplyLoadout;

["odaSpawn", format ["Spawned %1 [%2]", _slotId, _spawnPos]] call OSF_fnc_log;
_unit