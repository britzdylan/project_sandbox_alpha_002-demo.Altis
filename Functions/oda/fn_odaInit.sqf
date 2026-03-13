#include "..\..\scripts\constants.hpp"

// ---- ODA Roster ----
// Build roster hashmap from odaData.sqf slot definitions.
// Keyed by slotId. Names and identities are assigned at spawn time —
// only role structure is defined statically.
private _odaDefs = call compile preProcessFileLineNumbers "scripts\data\odaData.sqf";
private _odaRegistry = createHashMap;

{
	private _s = _x;
	private _slotMap = createHashMapFromArray [
		[OSF_ODA_SLOT_ID,           _s select 0],
		[OSF_ODA_RANK,              _s select 1],
		[OSF_ODA_ROLE,              _s select 2],
		[OSF_ODA_MOS,               _s select 3],
		[OSF_ODA_PASSIVE_BONUS,     _s select 4],
		// Runtime-only fields — seeded empty; populated at spawn
		[OSF_ODA_STATUS,            "active"], // active, KIA or 
		[OSF_ODA_IN_SQUAD,          true],
		[OSF_ODA_IDENTITY_CLASS,    ""],       // assigned by fn_odaAssignIdentity at spawn
		[OSF_ODA_LOADOUT,           "recon"],
		[OSF_ODA_UNIT_REF,          objNull],  // re-linked every load; never persisted
		[OSF_ODA_INCAPACITATED_TIMER,   -1],   // CBA handle; -1 = inactive
		[OSF_ODA_REPLACEMENT_TIMER,     -1]    // seconds remaining on 6h pipeline; -1 = inactive
	];
	_odaRegistry set [_s select 0, _slotMap];
} forEach _odaDefs;

[OSF_KEY_ODA_ROSTER, _odaRegistry] call OSF_fnc_setMissionVar;
["boot", format ["%1 ODA slot(s) initialized.", count (keys _odaRegistry)]] call OSF_fnc_log;