// ============================================================
// OSF_fnc_damageBuildings
// Randomly damage buildings within a trigger or position+radius.
//
// Arguments:
//   0: OBJECT or ARRAY — trigger object, OR [position, radius]
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
if (_minDmg > _maxDmg) then { _maxDmg = _minDmg };
_chance = 0 max _chance min 1;

// Find all buildings in radius
private _buildings = nearestObjects [_pos, ["House", "Building"], _radius];
private _count = 0;

{
    if (random 1 <= _chance) then {
        private _dmg = _minDmg + random (_maxDmg - _minDmg);
        _x setDamage [_dmg, false];  // false = no visual destruction effects during set
        if(_dmg > 0.5) then {
            _x setVariable ["tint_house_blacklisted", true];
        };
        _count = _count + 1;
    };
} forEach _buildings;

["damageBuildings", format ["Damaged %1 of %2 buildings (radius %3m)", _count, count _buildings, _radius]] call OSF_fnc_log;

_count
