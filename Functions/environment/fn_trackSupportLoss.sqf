// ============================================================
// OSF_fnc_trackSupportLoss
// Adds a Killed EH to a support vehicle that increments a
// per-class loss counter in missionNamespace.
//
// Variable format: OSF_supportLosses (HashMap: className -> count)
//
// Params: _this = the vehicle (object)
// Usage:  In support module vehicle init: this call OSF_fnc_trackSupportLoss;
// ============================================================

private _veh = _this;

_veh addEventHandler ["Killed", {
	params ["_unit"];
	private _class = typeOf _unit;
	private _losses = ["OSF_supportLosses", createHashMap] call OSF_fnc_getMissionVar;

	private _count = _losses getOrDefault [_class, 0];
	_count = _count + 1;
	_losses set [_class, _count];

	["OSF_supportLosses", _losses, true] call OSF_fnc_setMissionVar;

	systemChat format ["Support asset destroyed: %1 (total lost: %2)", _class, _count];
	["trackSupportLoss", format ["%1 destroyed — class total: %2", _class, _count]] call OSF_fnc_log;
}];
