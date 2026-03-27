// ============================================================
// OSF_fnc_addVehicleToGarage
// Finds all garages in a radius, randomly selects a subset,
// and spawns a random civilian vehicle inside each one.
// Sets "OSF_garageVehicle" variable on the vehicle.
// 
// Arguments:
//   0: ARRAY  — center position          (default: player pos)
//   1: NUMBER — search radius in meters  (default: 500)
//   2: NUMBER — chance per garage 0–1    (default: 0.5)
// 
// Returns: ARRAY — spawned vehicle objects
// ============================================================
#include "..\..\scripts\constants.hpp"

params [
	["_center", OSF_MAP_CENTER, [[]]],
	["_radius", 16000, [0]],
	["_chance", 0.4, [0]]
];

if (_center isEqualTo []) then {
	_center = getPos player
};
_count = 0;

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

private _garages = ["class", "Land_i_Garage_V1_F", _center, _radius] call OSF_fnc_findBuildings;

private _spawned = [];

{
	if (random 1 < _chance) then {
		private _garage = _x;
		private _spawnPos = _garage buildingPos 2;

		if !(_spawnPos isEqualTo [0, 0, 0]) then {
			_count = _count + 1;
			_garage setVariable ["tint_house_blacklisted", true];
			_garage setVariable ["OSF_skipDamage", true];
			private _type = selectRandom _vehicleTypes;
			private _veh = createVehicle [_type, [_spawnPos select 0, _spawnPos select 1, 0]];
			_veh allowDamage false;
			_veh enableDynamicSimulation true;
			_veh setDir (getDir _garage) + 90;
			_veh setPosATL (_veh modelToWorld [1.5, -1, -1.5]);
			_veh setVariable ["OSF_garageVehicle", true, true];
			_spawned pushBack _veh;
			_veh setFuel (0.1 + random 0.9);
			_veh setDamage (random 0.4);
			_veh allowDamage true;

			if (["OSF_debug", false] call OSF_fnc_getMissionVar) then {
				private _mName = format ["garage_veh_%1", _count];
				private _m = createMarkerLocal [_mName, getPosATL _x];
				_m setMarkerTypeLocal "c_car";
				_m setMarkerSizeLocal [0.5, 0.5];
				_m setMarkerColorLocal ("colorCivilian");
				_m setMarkerTextLocal "GV";
			};
		};
	};
} forEach _garages;

["environment", format ["addVehicleToGarage: %1/%2 garages got vehicles", count _spawned, count _garages], 3] call OSF_fnc_log;

_spawned