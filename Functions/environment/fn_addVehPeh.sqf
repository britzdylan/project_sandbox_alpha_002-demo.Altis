private _vehicleTypes = [
	"C_Hatchback_01_F",
	"C_Hatchback_01_sport_F",
	"C_Offroad_02_unarmed_F",
	"C_Offroad_01_F",
	"C_Offroad_01_covered_F",
	"C_Offroad_lxWS",
	"C_Offroad_01_repair_F",
	"C_Pickup_rf",
	"C_Pickup_covered_rf",
	"C_Pickup_repair_rf",
	"C_Quadbike_01_F",
	"C_SUV_01_F"
];
private _buildings = ["class", "Land_fs_roof_F", [16085.1, 16997.9, 0], 16000, true] call OSF_fnc_findBuildings;
private _blackListPos = [];
{
	if (random 1 < 0.25) then {
		continue
	};
	private _count = 1 + floor random 2;
	for "_i" from 1 to _count do {
		private _class = selectRandom _vehicleTypes;
		private _obj = _class createVehicle getPos _x;

		private _safePos = [];
		for "_attempt" from 1 to 20 do {
			_safePos = [_obj, 0, 30, 5, 0, 0.3, 0] call BIS_fnc_findSafePos;
			if (_safePos isEqualTo [0, 0] || {
				_safePos isEqualTo [0, 0, 0]
			}) then {
				continue
			};
			if !(isOnRoad _safePos) exitWith {};
		};
		_obj setPos [_safePos select 0, _safePos select 1, 0];
		_obj setDir random 360;

		if (["OSF_debug", false] call OSF_fnc_getMissionVar) then {
			private _mName = format ["peh_%1_%2", _forEachIndex, _i];
			private _m = createMarkerLocal [_mName, [_safePos select 0, _safePos select 1, 0]];
			_m setMarkerTypeLocal "hd_dot";
			_m setMarkerSizeLocal [0.3, 0.3];
			_m setMarkerColorLocal "ColorWhite";
			_m setMarkerTextLocal "VehPeh";
		};
	};
} forEach _buildings;