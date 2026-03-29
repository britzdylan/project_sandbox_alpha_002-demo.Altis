// ============================================================
// OSF_fnc_killedRadio
// Adds a Killed EH to all friendly (side player) units.
// On death, plays a CfgRadio message matching the unit's group callsign.
// 
// group-to-radio mapping is defined in OSF_killedRadioMap (HashMap).
// Groups not in the map get a generic fallback message.
// 
// call once from init.sqf:
//     [] call OSF_fnc_killedRadio;
// ============================================================

// Map groupId strings (lowercase) → CfgRadio class names
// Add entries here as you create sound files
private _groupRadioMap = createHashMapFromArray [
	["omega", "radioAlphaDown"]
	    // ["bravo 1", "radioBravoDown"],
	    // ["charlie 1", "radioCharlieDown"]
];

["OSF_killedRadioMap", _groupRadioMap] call OSF_fnc_setMissionVar;

{
	if (!(_x getVariable ["OSF_killedRadioEH", false]) && side group _x == side player) then {
		_x addEventHandler ["Killed", {
			params ["_unit", "_killer"];

			private _grpId = groupId (group _unit);
			private _map = ["OSF_killedRadioMap", createHashMap] call OSF_fnc_getMissionVar;
			private _radioClass = _map getOrDefault [toLower _grpId, ""];

			if (_radioClass != "") then {
				[west, "HQ"] sideRadio _radioClass;
			} else {
				["killedRadio", format ["No radio mapping for group '%1' — unit: %2", _grpId, name _unit], OSF_LOG_WARNING] call OSF_fnc_log;
			};
		}];

		_x setVariable ["OSF_killedRadioEH", true];
	};
} forEach allUnits;

["killedRadio", format ["Killed radio EH applied. %1 unit(s) processed.", count allUnits], OSF_LOG_INFO] call OSF_fnc_log;