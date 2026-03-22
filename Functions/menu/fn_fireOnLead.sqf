private _squadUnits = (units group player) - [player];

// save current state for each unit and lock them to hold fire
{
	_x setCombatMode "BLUE";     // hold fire
} forEach _squadUnits;

// wait for player to fire then release all units simultaneously
private _firEH = player addEventHandler ["Fired", {
	params ["_unit"];

	private _squadUnits = (units group player) - [player];

	{
		_x setCombatMode "RED";
	} forEach _squadUnits;

	player removeEventHandler ["Fired", _thisEventHandler];
}];