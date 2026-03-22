private _squadUnits = (units group player) - [player];
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