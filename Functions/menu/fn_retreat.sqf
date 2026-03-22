/*
	Function:    fn_retreat
	Description: Moves the squad away from the nearest enemy in pairs, 150m to the rear.
	             All units drop prone and watch 360° on call. Pairs move under smoke cover
	             one at a time with a 15s timeout per pair in case of stuck units.
	             On arrival each pair holds in AWARE/WHITE/AUTO.
	Use when:    Unexpected contact. Not suited for breaking out of a large ongoing engagement.
*/
params [["_teamColor", ""]];
private _squadUnits = [];
if (_teamColor == "") then {
	_squadUnits = (units group player) - [player];
} else {
	_squadUnits = units group player select {
		assignedTeam _x == _teamColor
	};
};
private _numUnits = count _squadUnits;
private _defendRadius = 20 max ((count _squadUnits) * 2);
private _blackListPos = [];
private _nearestEnemy = player findNearestEnemy player;

private _retreatBearing = if (!isNull _nearestEnemy) then {
	(player getDir _nearestEnemy) + 180
} else {
	(getDir player) + 180
};

private _pos = getPos player;

private _retreatPos = [
	(_pos select 0) + 150 * sin(_retreatBearing),
	(_pos select 1) + 150 * cos(_retreatBearing),
	0
];

if (_numUnits == 0) exitWith {};

// all units drop prone immediately
{
	if (alive _x) then {
		_x setUnitCombatMode "RED";
		_x setCombatBehaviour "COMBAT";
		_x setUnitPos "DOWN";
		doStop _x;

		private _watchDir = _forEachIndex * (360 / _numUnits);
		_x doWatch (_x getRelPos [100, _watchDir]);
	};
} forEach _squadUnits;

// send units forward in pairs
private _i = 0;
sleep 1;
while { _i < _numUnits } do {
	private _pair = _squadUnits select [_i, (2 min (_numUnits - _i))];
	private _pairTargets = [];

	private _safePos = [_retreatPos, 0, _defendRadius, 0, 0, 0.5, 0, _blackListPos] call BIS_fnc_findSafePos;
	if (_safePos isEqualTo [0, 0, 0]) then {
		_safePos = _retreatPos;
	} else {
		_blackListPos pushBack [_safePos, 8];
	};

	{
		if (alive _x) then {
			_x setUnitPos "UP";
			_x setSpeedMode "FULL";
			_x setCombatBehaviour "AWARE";
			_x setUnitCombatMode "GREEN";
			createVehicle ["SmokeShell", getPos _x, [], 0, "NONE"];
			_x doMove _safePos;
			_pairTargets pushBack [_x, _safePos];
		};
	} forEach _pair;

	private _startTime = time;
	waitUntil {
		sleep 1;
		(_pairTargets select {
			((_x select 0) distance (_x select 1)) > 2 && {
				alive (_x select 0)
			}
		}) isEqualTo [] || {
			(time - _startTime) > 15
		}
	};

	{
		if (alive _x) then {
			_x setUnitCombatMode "WHITE";
			_x setCombatBehaviour "AWARE";
			_x setUnitPos "AUTO";
		};
	} forEach _pair;

	_i = _i + 2;
};