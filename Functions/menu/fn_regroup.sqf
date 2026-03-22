/*
	Function:    fn_regroup
	Description: Orders all squad units to follow the player and mirror the player's stance.
	             units resume formation on the player. while following, any stance change
	             by the player (stand/crouch/prone) is automatically copied by each unit
	             that still has the player as their formation leader.
	Use when:    After advance, retreat, or any order that broke formation.
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
_squadUnits commandFollow player;

player addEventHandler ["AnimChanged", {
	params ["_unit", "_anim"];
	private _stance = stance _unit;
	private _unitPos = switch (_stance) do {
		case "STAND": {
			"UP"
		};
		case "CROUCH": {
			"MIDDLE"
		};
		case "PRONE": {
			"DOWN"
		};
		default {
			""
		};
	};

	if (_unitPos == "") exitWith {};

	{
		if (alive _x && {
			formationLeader _x == player
		}) then {
			_x setUnitPos _unitPos;
		};
	} forEach ((units group player) - [player]);
}];