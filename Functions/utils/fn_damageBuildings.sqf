// ============================================================
// OSF_fnc_damageBuildings
// Randomly damage buildings within a trigger or position+radius.
// 
// Arguments:
//   0: OBJECT or ARRAY — trigger object, or [position, radius]
//   1: NUMBER (optional) — minimum damage per building (default 0.3)
//   2: NUMBER (optional) — maximum damage per building (default 1.0)
//   3: NUMBER (optional) — chance each building is damaged, 0–1 (default 0.7)
// 
// Usage:
//   [myTrigger] call OSF_fnc_damageBuildings;
//   [myTrigger, 0.5, 1.0, 0.8] call OSF_fnc_damageBuildings;
//   [[getPos player, 200], 0.2, 0.9] call OSF_fnc_damageBuildings;
// 
// Returns: NUMBER — count of buildings damaged
// ============================================================

// Debris classnames — scattered around damaged buildings as simple objects
private _debrisClasses = [
	"Land_Tyres_F",
	"Land_FieldToilet_F",
	"Land_Pallets_F",
	"Land_CinderBlocks_01_F",
	"Land_Garb_heap_01_F",
	"Land_GarbageBags_F",
	"Land_JunkPile_F",
	"Land_Garbage_square3_F",
	"Land_Garbage_square5_F",
	"Land_Garbage_line_F",
	"Land_ConcretePipe_F",
	"Land_Bricks_V4_F",
	"Land_Pipes_Small_F",
	"Land_BurntGarbage_01_F",
	"Land_PaperBox_01_small_destroyed_brown_F",
	"Land_PaperBox_01_small_open_brown_IDAP_F",
	"Land_PaperBox_01_small_ransacked_brown_IDAP_F",
	"Land_FoodSack_01_empty_brown_idap_F",
	"Land_FoodSack_01_empty_white_idap_F",
	"Land_FoodSacks_01_large_white_idap_F",
	"Land_FoodSacks_01_small_brown_idap_F",
	"Land_LuggageHeap_03_F",
	"Land_LuggageHeap_01_F",
	"Land_LuggageHeap_02_F",
	"Land_LuggageHeap_05_F",
	"Land_LuggageHeap_04_F",
	"Oil_Spill_F",
	"Land_Tyres_F",
	"Land_WaterBottle_01_compressed_F"
];

// Heavy wreckage — only near heavily damaged buildings (>0.7)
private _wreckClasses = [
	"Land_Wreck_Car_F",
	"Land_Wreck_Car2_F",
	"Land_Wreck_Car3_F",
	"Land_Wreck_Truck_dropside_F",
	"Land_Wreck_Truck_F",
	"Land_GarbageContainer_closed_F",
	"Land_GarbageContainer_open_F",
	"Land_BarrelTrash_F",
	"Land_BarrelTrash_grey_F",
	"WaterPump_01_forest_F",
	"Land_Wreck_HMMWV_F",
	"Land_GarbageWashingMachine_F",
	"Land_GarbageHeap_01_F"
];

params [
	["_source", objNull, [objNull, []]],
	["_minDmg", 0.3, [0]],
	["_maxDmg", 1.0, [0]],
	["_chance", 0.7, [0]]
];

// Resolve position and radius from trigger or [pos, radius] array
private ["_pos", "_radius"];

if (_source isEqualType objNull) then {
	_pos = getPos _source;
	    _radius = (triggerArea _source) select 0;  // uses the 'a' axis
} else {
	_pos = _source select 0;
	_radius = _source select 1;
};

// Clamp values
_minDmg = 0 max _minDmg min 1;
_maxDmg = 0 max _maxDmg min 1;
if (_minDmg > _maxDmg) then {
	_maxDmg = _minDmg
};
_chance = 0 max _chance min 1;

// find actual buildings — filter out poles, lamps, fences etc. by requiring building positions
private _buildings = nearestObjects [_pos, ["House", "Building"], _radius] select {
	count (_x buildingPos -1) >= 3
};
private _count = 0;

{
	if (random 1 < _chance) then {
		private _dmg = _minDmg + random (_maxDmg - _minDmg);
		_x setDamage [_dmg, false];
		if (_dmg > 0.5) then {
			_x setVariable ["tint_house_blacklisted", true];
		};
		_count = _count + 1;

		        // --- Debug marker (remove for release) ---
		if (["OSF_debug", false] call OSF_fnc_getMissionVar) then {
			private _mName = format ["dbg_dmg_%1", _count];
			private _m = createMarkerLocal [_mName, getPosATL _x];
			_m setMarkerTypeLocal "mil_dot";
			_m setMarkerSizeLocal [0.5, 0.5];
			_m setMarkerColorLocal (if (_dmg > 0.7) then {
				"ColorRed"
			} else {
				if (_dmg > 0.4) then {
					"ColorOrange"
				} else {
					"ColorYellow"
				}
			});
			_m setMarkerTextLocal format ["%1%%", round (_dmg * 100)];
		};

		        // --- spawn debris around damaged building ---
		private _bPos = getPos _x;

		        // Scale clutter amount by damage: light damage = 1-2, heavy = 3-6
		private _numDebris = round (1 + _dmg * 5);

		for "_i" from 1 to _numDebris do {
			// Pick from heavy wreck pool for high damage, otherwise light debris
			private _class = if (_dmg > 0.8 && {random 1 < 0.05}) then {
				selectRandom _wreckClasses
			} else {
				if (random 1 < 0.1) then {selectRandom _debrisClasses} else {""}
			};

			if (_class == "") then {continue};
			private _obj = createSimpleObject [_class, _bPos];
			private _safePos = [_obj, 15, 25, 1, 0, 0.3, 0] call BIS_fnc_findSafePos;
			_obj setDir random 360;
			private _normal = surfaceNormal _bPos;
			_obj setPosATL [_safePos select 0, _safePos select 1, 0];
			_obj setVectorUp _normal;

			// --- Debug marker for debris ---
			if (["OSF_debug", false] call OSF_fnc_getMissionVar) then {
				private _mName = format ["dbg_debris_%1_%2", _count, _i];
				private _m = createMarkerLocal [_mName, [_safePos select 0, _safePos select 1, 0]];
				_m setMarkerTypeLocal "mil_triangle";
				_m setMarkerSizeLocal [0.3, 0.3];
				_m setMarkerColorLocal "ColorBlue";
				_m setMarkerTextLocal _class;
			};
		};
	};
} forEach _buildings;

["damageBuildings", format ["Damaged %1 of %2 buildings (radius %3m, debris spawned)", _count, count _buildings, _radius]] call OSF_fnc_log;

_count