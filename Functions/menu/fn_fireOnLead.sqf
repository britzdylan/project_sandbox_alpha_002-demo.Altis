/*
	Function:    fn_fireOnLead
	Description: Holds the squad at cease-fire until the player fires their weapon.
	             On player fire, all units simultaneously switch to ENGAGE (RED).
	             The event handler is self-removing after the first player shot.
	Use when:    Coordinated ambushes or volley fire on a single trigger.
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