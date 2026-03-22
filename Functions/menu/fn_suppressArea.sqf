private _pos = cursorTarget;
private _squadUnits = (units group player) - [player];
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