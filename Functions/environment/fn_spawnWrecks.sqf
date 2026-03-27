// ============================================================
// OSF_fnc_spawnOpenField
// Finds 27 large open spaces around a center point and spawns
// objects at each location.
// 
// Arguments:
//   0: ARRAY — center position [x, y, z]
// 
// Usage:
//   [[16083.6, 16997.1, 0]] call OSF_fnc_spawnOpenField;
// 
// Returns: ARRAY — list of spawned positions
// ============================================================

params [
	["_center", [16083.6, 16997.1, 0], [[]]]
];

private _positions = [];

private _wreckClasses = [
	"Land_Wreck_MBT_04_F",
	"Land_Wreck_LT_01_F",
	"Land_Wreck_Slammer_F",
	"Land_Wreck_Slammer_hull_F",
	"Land_Wreck_Slammer_turret_F",
	"Land_Wreck_T72_hull_F",
	"Land_Wreck_T72_turret_F",
	"Land_Wreck_Plane_Transport_01_crashed_F",
	"Land_Wreck_Plane_Transport_01_F",
	"Land_Bulldozer_01_wreck_F",
	"Land_Excavator_01_wreck_F",
	"Land_PowerGenerator_wreck_F",
	"Land_TrailerCistern_wreck_F",
	"Land_MiningShovel_01_abandoned_F",
	"Land_Wreck_Heli_Attack_01_F",
	"Land_Heli_EC_01_wreck_RF",
	"Land_Mi8_wreck_F",
	"Land_Wreck_Heli_Attack_02_F",
	"Land_Wreck_Heli_02_Wreck_01_F",
	"Land_Wreck_BMP2_F",
	"Land_Wreck_AFV_Wheeled_01_F",
	"Land_Wreck_BRDM2_F"
];

for "_i" from 1 to 27 do {
	private _safePos = [_center, 150, 8000, 15, 0, 0.3, 0] call BIS_fnc_findSafePos;
	private _class = selectRandom _wreckClasses;

	// spawn something at _safePos
	private _obj = createSimpleObject [_class, _center];
	_obj setDir random 360;
	private _normal = surfaceNormal _safePos;
	_obj setPosATL [_safePos select 0, _safePos select 1, 0];
	_obj setVectorUp _normal;

	_positions pushBack _safePos;

	// --- Debug marker ---
	if (["OSF_debug", false] call OSF_fnc_getMissionVar) then {
		private _mName = format ["dbg_openfield_%1", _i];
		private _m = createMarkerLocal [_mName, _safePos];
		_m setMarkerTypeLocal "Contact_circle1";
		_m setMarkerSizeLocal [0.6, 0.6];
		_m setMarkerColorLocal "ColorGreen";
		_m setMarkerTextLocal format ["Open %1", _i];
	};
};

["spawnOpenField", format ["Found %1 open field positions", count _positions]] call OSF_fnc_log;

_positions