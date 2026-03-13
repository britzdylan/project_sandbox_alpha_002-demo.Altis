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
		[OSF_TOC_STRATEGIC_WEATHER, _toc select 4],
		[OSF_TOC_STRATEGIC_TIME, _toc select 5]
	];
	_tocRegistry set [_toc select 0, _tocMap];
} forEach _tocDefs;

[OSF_KEY_TOC_STATE, _tocRegistry] call OSF_fnc_setMissionVar;
["initGameState", format ["%1 TOC data initialized.", count (keys _tocRegistry)]] call OSF_fnc_log;

// ---- TOC Strategic Map HoldActions ----

{
	private _tocId = _x;
	private _entry = _tocRegistry get _tocId;
	private _objVarName = _entry get OSF_TOC_STRATEGIC_OBJ_ID;
	private _obj = missionNamespace getVariable [_objVarName, objNull];

	if (isNull _obj) exitWith {
		["tocInit", format ["WARNING: TOC object '%1' not found for TOC '%2'", _objVarName, _tocId]] call OSF_fnc_log;
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
	[
		_obj,
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
		2,
		0,
		false,
		false,
		true
	] call BIS_fnc_holdActionAdd;

	["tocInit", format ["Hold action added for TOC '%1' on object '%2'", _tocId, _objVarName]] call OSF_fnc_log;
} forEach (keys _tocRegistry);