// ============================================================
// OSF_fnc_tocInit
// Attaches hold actions to all TOC strategic map board objects.
// Called once from init.sqf after OSF_tocState is populated.
// 
// params: none
// Returns: nothing
// Usage: [] call OSF_fnc_tocInit;
// ============================================================
#include "..\..\scripts\constants.hpp"

// ---- TOC State ----
private _tocDefs = call compile preProcessFileLineNumbers "scripts\data\tocData.sqf";
private _tocRegistry = createHashMap;

{
	private _toc = _x;
	private _tocMap = createHashMapFromArray [
		[OSF_TOC_ID, _toc select 0],
		[OSF_TOC_POS, _toc select 1],
		[OSF_TOC_STRATEGIC_MISSION, _toc select 2],
		[OSF_TOC_STRATEGIC_OBJ_ID, _toc select 3],
		[OSF_TOC_SQUAD_MANAGER_OBJ_ID, _toc select 4],
		[OSF_TOC_FIA_MANAGER_OBJ_ID, _toc select 5]
	];
	_tocRegistry set [_toc select 0, _tocMap];
} forEach _tocDefs;

[OSF_KEY_TOC_STATE, _tocRegistry] call OSF_fnc_setMissionVar;
["initGameState", format ["%1 TOC data initialized.", count (keys _tocRegistry)]] call OSF_fnc_log;

// ---- TOC Supply Loadout ----
[] spawn OSF_fnc_tocApplySupplyLoadout;
[] spawn OSF_fnc_tocSupplyWatcher;

// ---- TOC HoldActions ----

{
	private _tocId = _x;
	private _entry = _tocRegistry get _tocId;

	private _strategicMapObjVarName = _entry get OSF_TOC_STRATEGIC_OBJ_ID;
	private _strategicMapObj = missionNamespace getVariable [_strategicMapObjVarName, objNull];

	private _squadManagerObjVarName = _entry get OSF_TOC_SQUAD_MANAGER_OBJ_ID;
	private _squadManagerObj = missionNamespace getVariable [_squadManagerObjVarName, objNull];

	private _fiaManagerObjVarName = _entry get OSF_TOC_FIA_MANAGER_OBJ_ID;
	private _fiaManagerObj = missionNamespace getVariable [_fiaManagerObjVarName, objNull];

	if (isNull _strategicMapObj) exitWith {
		["tocInit", format ["WARNING: TOC object '%1' not found for TOC '%2'", _squadManagerObjVarName, _tocId]] call OSF_fnc_log;
	};

	if (isNull _squadManagerObj) exitWith {
		["tocInit", format ["WARNING: TOC object '%1' not found for TOC '%2'", _squadManagerObjVarName, _tocId]] call OSF_fnc_log;
	};

	/* [
			    target, 
			    title, 
			    idleIcon, 
			    progressIcon, 
			    conditionShow, 
			    conditionProgress, 
			    codeStart, 
			    codeProgress, 
			    codeCompleted, 
			    codeInterrupted, 
			    arguments, 
			    duration, 
			    priority, 
			    removeCompleted, 
			    showUnconscious, 
			    showWindow
		    ]
	    */

	// ------ Strategic Map
	[
		_strategicMapObj,
		"Open Operations Map",
		"\a3\ui_f\data\igui\cfg\actions\take_ca.paa",
		"\a3\ui_f\data\igui\cfg\actions\take_ca.paa",
		"(_this distance _target) < 2",
		"(_this distance _target) < 2",
		{},
		{},
		{
			[_this select 3 select 0] call OSF_fnc_strategicMapOpen;
		}, // _this#3 = arguments array
		{},
		[_entry],
		1,
		0,
		false,
		false,
		true
	] call BIS_fnc_holdActionAdd;

	// ------ Squad Manager
	[
		_squadManagerObj,
		"Open squad management",
		"\a3\ui_f\data\igui\cfg\actions\take_ca.paa",
		"\a3\ui_f\data\igui\cfg\actions\take_ca.paa",
		"(_this distance _target) < 2",
		"(_this distance _target) < 2",
		{},
		{},
		{
			[] call OSF_fnc_tocSquadUI;
		}, // _this#3 = arguments array
		{},
		[],
		1,
		0,
		false,
		false,
		true
	] call BIS_fnc_holdActionAdd;

	// ------ FIA Manager
	[
		_fiaManagerObj,
		"Open FIA management",
		"\a3\ui_f\data\igui\cfg\actions\take_ca.paa",
		"\a3\ui_f\data\igui\cfg\actions\take_ca.paa",
		"(_this distance _target) < 2",
		"(_this distance _target) < 2",
		{},
		{},
		{
			[] call OSF_fnc_tocMilitiaUI;
		}, // _this#3 = arguments array
		{},
		[],
		1,
		0,
		false,
		false,
		true
	] call BIS_fnc_holdActionAdd;
} forEach (keys _tocRegistry);