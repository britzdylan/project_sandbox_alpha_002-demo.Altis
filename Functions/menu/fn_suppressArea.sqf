/*
	Function:    fn_suppressArea
	Description: Orders all squad units to suppress the player's current cursor target
	             for 20 seconds. Each unit is spawned independently so suppression
	             runs in parallel. Units are forced into COMBAT/RED regardless of
	             their current behavior.
	Use when:    Pinning an enemy position while the player or another element maneuvers.
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
private _pos = cursorTarget;
private _duration = 20;

{
	[_x, _pos, _duration] spawn {
		params ["_unit", "_pos", "_duration"];

		// force into firing state regardless of current behaviour
		_unit setBehaviour "COMBAT";
		_unit setCombatMode "RED";

		_unit doWatch _pos;

		_unit doTarget _pos;
		_unit suppressFor _duration;
	};
} forEach _squadUnits;