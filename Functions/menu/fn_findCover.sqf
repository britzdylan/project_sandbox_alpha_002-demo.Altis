/*
	Function:    fn_findCover
	Description: Disperses squad units to nearby cover around the player's position.
	             Each unit is assigned a unique safe position within the defend radius.
	             If an empty static weapon emplacement is nearby, the unit crews it instead.
	             Units set up in COMBAT/YELLOW facing forward once in position.
	             Uses a 60s movement timeout per unit to prevent stalling.
	Use when:    Taking fire and needing the squad to break from formation and find cover.
*/
if (missionNamespace getVariable ["OSF_advanceActive", false]) then {
	missionNamespace setVariable ["OSF_advanceActive", false];
};

params [["_teamColor", ""]];
private _squadUnits = [];
if (_teamColor == "") then {
	_squadUnits = (units group player) - [player];
} else {
	_squadUnits = units group player select {
		assignedTeam _x == _teamColor
	};
};
private _blackListPos = [];
private _origin = getPos player;
private _watchPos = player getRelPos [500, 0];
private _defendRadius = 30 max ((count _squadUnits) * 5);

// find all empty static weapon emplacements within the defend radius, friendly/neutral only
private _availableEmplacements = (nearestObjects [_origin, ["StaticWeapon"], _defendRadius]) select {
	count (crew _x) == 0;
};

{
	private _unit = _x;

	sleep 1;

	// prefer an empty static emplacement if one is available
	private _emplacement = if (count _availableEmplacements > 0) then {
		_availableEmplacements deleteAt 0
	} else {
		objNull
	};

	if (!isNull _emplacement) then {
		_unit moveInGunner _emplacement;
		_blackListPos pushBack [getPos _emplacement, 8];

		[_unit] spawn {
			params ["_unit"];
			waitUntil {
				sleep 1;
				(unitReady _unit) || !(alive _unit)
			};
			if (alive _unit) then {
				_unit setBehaviour "COMBAT";
			};
		};
	} else {
		private _pos = [_origin, 0, _defendRadius, 0, 0, 0.5, 0, _blackListPos] call BIS_fnc_findSafePos;

		// guard against BIS_fnc_findSafePos returning map origin on failure
		if (_pos isEqualTo [0, 0, 0]) exitWith {};

		_unit doMove _pos;
		_unit setSpeedMode "FULL";
		_blackListPos pushBack [_pos, 8];

		[_unit, _pos, _watchPos] spawn {
			params ["_unit", "_pos", "_watchPos"];
			private _timeout = time + 60;
			waitUntil {
				sleep 1;
				(_unit distance2D _pos < 5) || !(alive _unit) || (time > _timeout)
			};
			if (alive _unit) then {
				_unit setSpeedMode "NORMAL";
				_unit setBehaviour "COMBAT";
				_unit setCombatMode "YELLOW";
				_unit doWatch _watchPos;
			};
		};
	};
} forEach _squadUnits;