/*
	Function:    fn_advance
	Description: Sends the squad forward in pairs toward a position 75m ahead of the player.
	             On call, all units immediately drop prone and watch 360°. After a short delay,
	             pairs move up one at a time, each waiting to arrive before the next departs.
	             On arrival each pair goes prone and holds in AWARE/WHITE.
	Use when:    Ideal for covering open terrain or bounding forward. do not use on confined spaces like towns. Pairs can easily be ambushed by undetected enemies
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

if (_numUnits == 0) exitWith {};

// all units drop prone immediately
{
	if (alive _x) then {
		_x setUnitCombatMode "WHITE";
		_x setCombatBehaviour "AWARE";
		_x setUnitPos "DOWN";
		doStop _x;

		private _watchDir = _forEachIndex * (360 / _numUnits);
		_x doWatch (_x getRelPos [100, _watchDir]);
	};
} forEach _squadUnits;

private _playerPos = getPos player;
private _forwardPos = player getRelPos [75, 0];

// send units forward in pairs
private _i = 0;
sleep 5;
while { _i < _numUnits } do {
	private _pair = _squadUnits select [_i, (2 min (_numUnits - _i))];
	private _pairTargets = [];

	private _safePos = [_forwardPos, 0, _defendRadius, 0, 0, 0.5, 0, _blackListPos] call BIS_fnc_findSafePos;
	if (_safePos isEqualTo [0, 0, 0]) then {
		_safePos = _forwardPos;
	} else {
		_blackListPos pushBack [_safePos, 8];
	};

	{
		if (alive _x) then {
			_x setUnitPos "UP";
			_x setSpeedMode "FULL";
			_x setCombatBehaviour "CARELESS";
			_x setUnitCombatMode "BLUE";
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
			_x setUnitPos "DOWN";
		};
	} forEach _pair;

	_i = _i + 2;
};