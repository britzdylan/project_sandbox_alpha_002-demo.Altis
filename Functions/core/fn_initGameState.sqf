// ============================================================
// OSF_fnc_initGameState
// Bootstraps all global game state on mission start.
// Called once from init.sqf.
// 
// Flow:
//   1. Check profileNamespace for a saved game
//   2a. if save exists → restore via fn_loadState (restores sector hashmap + markers)
//   2b. if no save    → build fresh hashmap from sectorData.sqf, initialize markers
//   3. (init.sqf continues) Re-register HBQ module object refs and other
//      Eden-placed object references that can't survive session boundaries.
// 
// params: none
// Returns: nothing
// Usage:  [] call OSF_fnc_initGameState;
// ============================================================

#include "..\..\scripts\constants.hpp"

params [];

["initGameState", "starting..."] call OSF_fnc_log;

// ---- Global state ----
// These are always initialized fresh; they are written to profileNamespace
// separately by fn_saveState and restored by fn_loadState (extend those
// functions as new systems are added in later phases).
[OSF_KEY_DEBUG,           true] call OSF_fnc_setMissionVar;   // set false for release
[OSF_KEY_OP_FAILURES,       0] call OSF_fnc_setMissionVar;   // game over at 3
[OSF_KEY_CAMPAIGN_PHASE,    1] call OSF_fnc_setMissionVar;   // 1=early, 2=mid, 3=late
[OSF_KEY_ASSET_INVENTORY,  []] call OSF_fnc_setMissionVar;   // populated by requisition system (B5)

// ---- ODA Roster ----
// Build roster hashmap from odaData.sqf static definitions.
// Each member is keyed by id. Runtime-only fields seeded empty here.
private _odaDefs = call compile preProcessFileLineNumbers "scripts\data\odaData.sqf";
private _odaRegistry = createHashMap;

{
	private _m = _x;
	private _memberMap = createHashMapFromArray [
		["id", _m select 0],
		["name", _m select 1],
		["role", _m select 2],
		["mos", _m select 3],
		["status", _m select 4],
		["inSquad", _m select 5],
		["passiveBonus", _m select 6],
		        // Runtime-only fields — seeded empty
		["incapTimer", -1], // scheduled CBA/sleep handle; -1 = inactive
		["replacementTimer", -1]    // seconds remaining on 6h pipeline; -1 = inactive
	];
	_odaRegistry set [_m select 0, _memberMap];
} forEach _odaDefs;

[OSF_KEY_ODA_ROSTER, _odaRegistry] call OSF_fnc_setMissionVar;
["initGameState", format ["%1 ODA member(s) initialized.", count (keys _odaRegistry)]] call OSF_fnc_log;

// ---- Sector state ----

// load static sector definitions
private _sectorDefs = call compile preProcessFileLineNumbers "scripts\data\sectorData.sqf";

private _registry = createHashMap;

{
	private _def = _x;

	private _sectorMap = createHashMapFromArray [
		["id", _def select 0],
		["displayName", _def select 1],
		["operationId", _def select 2],
		["boundaryMarker", _def select 3],
		["status", _def select 4],
		["adjacency", _def select 5],
		["commandPoints", _def select 6],
		["importance", _def select 7],
		["sideObjectives", _def select 8],
		            // Runtime-only fields — seeded empty
		["completedSideObjectives", []],
		["counterattackActive", false]
	];

	_registry set [_def select 0, _sectorMap];
} forEach _sectorDefs;

[OSF_KEY_SECTOR_STATE, _registry] call OSF_fnc_setMissionVar;

    // Initialize markers for all sectors
{
	[_x] call OSF_fnc_updateMarker;
} forEach (keys _registry);

["initGameState", format ["%1 sector(s) initialized.", count (keys _registry)]] call OSF_fnc_log;

[] call OSF_fnc_tocInit;

["initGameState", "complete."] call OSF_fnc_log;
