// ============================================================
// OSF_fnc_findBuildings
// ORM-style building query tool. Finds terrain buildings around
// a center point and filters by a query type, then marks results.
// 
// Arguments:
//   0: STRING  — query type (see below)
//   1: ANY     — query value (depends on mode)
//   2: ARRAY   — center position [x, y, z]  (optional, defaults to player)
//   3: NUMBER  — search radius in meters     (optional, defaults to 500)
// 
// Query Types:
//   all       — all buildings (value: ignored)
//   positions — buildings with exactly N building positions (value: NUMBER)
//   minpositions — buildings with >= N building positions (value: NUMBER)
//   variable  — buildings where getVariable [key, nil] is not nil (value: STRING key)
//   class     — buildings with exact class match (value: STRING)
//   like      — buildings whose class contains the substring (value: STRING)
// 
// Usage:
//   ["all", nil, getPos player, 800] call OSF_fnc_findBuildings;
//   ["positions", 1, getPos player, 500] call OSF_fnc_findBuildings;
//   ["minpositions", 4, getPos player, 600] call OSF_fnc_findBuildings;
//   ["variable", "myVar", getPos player, 400] call OSF_fnc_findBuildings;
//   ["class", "Land_i_House_Small_01_V1_F", getPos player, 500] call OSF_fnc_findBuildings;
//   ["like", "House", getPos player, 800] call OSF_fnc_findBuildings;
// 
// Returns: ARRAY — matched building objects
// ============================================================

params [
	["_query", "all", [""]],
	["_value", nil ],
	["_center", [0, 0, 0], [[]]],
	["_radius", 500, [0]],
    ["_showMarkers", false, [true]]
];

// --- Resolve center ---
if (_center isEqualTo [0, 0, 0]) then {
	_center = if (isNull player) then [{
		[worldSize / 2, worldSize / 2, 0]
	}] else [{
		getPos player
	}];
};

// --- Helper: count building positions ---
private _fnc_posCount = {
	params ["_bld"];
	private _i = 0;
	while { !(_bld buildingPos _i isEqualTo [0, 0, 0]) } do {
		_i = _i + 1
	};
	_i
};

// --- Fetch all buildings in radius ---
private _allBuildings = nearestObjects [_center, ["House"], _radius];

// --- Filter by query ---
private _q = toLower _query;
private _results = [];
private _color = "ColorWhite";

if (_q == "all") then {
	_results = _allBuildings;
	_color = "ColorWhite";
} else {
	if (_q == "positions") then {
		private _target = _value;
		_results = _allBuildings select {
			([_x] call _fnc_posCount) == _target
		};
		_color = "ColorRed";
	} else {
		if (_q == "minpositions") then {
			private _min = _value;
			_results = _allBuildings select {
				([_x] call _fnc_posCount) >= _min
			};
			_color = "ColorOrange";
		} else {
			if (_q == "variable") then {
				private _key = _value;
				_results = _allBuildings select {
					!(isNil {
						_x getVariable _key
					})
				};
				_color = "ColorBlue";
			} else {
				if (_q == "class") then {
					private _cls = _value;
					_results = _allBuildings select {
						typeOf _x == _cls
					};
					_color = "ColorGreen";
				} else {
					if (_q == "like") then {
						private _sub = toLower _value;
						_results = _allBuildings select {
							_sub in (toLower typeOf _x)
						};
						_color = "ColorYellow";
					} else {
						["findBuildings", format ["Unknown query type: '%1'", _query]] call OSF_fnc_log;
					};
				};
			};
		};
	};
};

// --- Clear previous findBuildings markers ---
{
	if (_x find "osf_fb_" == 0) then {
		deleteMarkerLocal _x
	};
} forEach allMapMarkers;

// --- Place markers ---
if (_showMarkers) then {
	{
		private _bld = _x;
		private _posCount = [_bld] call _fnc_posCount;
		private _mName = format ["osf_fb_%1", _forEachIndex];
		private _m = createMarkerLocal [_mName, getPosATL _bld];
		_m setMarkerTypeLocal "mil_dot";
		_m setMarkerColorLocal _color;
		_m setMarkerSizeLocal [0.4, 0.4];
		_m setMarkerTextLocal format ["%1 (%2pos)", typeOf _bld, _posCount];
	} forEach _results;
};

// --- Report ---
private _msg = format ["findBuildings [%1]: %2 results in %3m radius", _query, count _results, _radius];
systemChat _msg;
["findBuildings", _msg] call OSF_fnc_log;

_results