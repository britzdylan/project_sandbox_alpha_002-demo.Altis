// ============================================================
// OSF_fnc_setSector
// Sets a named field in a sector's runtime state hashmap and
// fires any relevant side effects for that field.
// 
// This is the ONLY function that should mutate sector state.
// All other scripts call this — never write to the hashmap directly.
// 
// params: [sectorID (string), fieldName (string), value (any)]
// Returns: nothing
// Usage:  ["sector_tutorial", "status", "liberated"] call OSF_fnc_setSector;
// ============================================================

#include "..\..\scripts\constants.hpp"

params ["_sectorID", "_fieldName", "_value"];

private _registry = [OSF_KEY_SECTOR_STATE, createHashMap] call OSF_fnc_getMissionVar;
private _sectorMap = _registry getOrDefault [_sectorID, nil];

if (isNil "_sectorMap") exitWith {
	["setSector", format ["unknown sectorID '%1'", _sectorID]] call OSF_fnc_log;
};

_sectorMap set [_fieldName, _value];

// ---- side effects ------------------------------------------------
switch (_fieldName) do {
	case "status": {
		// Always sync the map marker
		[_sectorID] call OSF_fnc_updateMarker;

		        // On liberation: disable HBQ respawn for this sector's spawn modules
		if (_value == "liberated") then {
			private _hbqModules = _sectorMap getOrDefault ["hbqModules", []];
			{
				// HBQ disable — adjust method name to match your HBQ version
				                // Common options: HBQ_fnc_setRespawnActive, or setting a module variable
				if (!isNull _x) then {
					_x setVariable ["HBQ_respawn", false, false];
				};
			} forEach _hbqModules;

			["setSector", format ["sector '%1' liberated. HBQ respawn disabled.", _sectorID]] call OSF_fnc_log;
		};

		        // On reversion to occupied (counterattack loss): re-enable HBQ respawn
		if (_value == "occupied") then {
			private _hbqModules = _sectorMap getOrDefault ["hbqModules", []];
			{
				if (!isNull _x) then {
					_x setVariable ["HBQ_respawn", true, false];
				};
			} forEach _hbqModules;

			            // Clear militia — all militia are lost when sector reverts
			private _militia = _sectorMap getOrDefault ["militia", []];
			{
				if (!isNull _x && {
					alive (leader _x)
				}) then {
					{
						deleteVehicle _x
					} forEach units _x;
				};
				deleteGroup _x;
			} forEach _militia;
			_sectorMap set ["militia", []];

			["setSector", format ["sector '%1' reverted to occupied. Militia cleared.", _sectorID]] call OSF_fnc_log;
		};
	};

	case "counterattackActive": {
		// Hook for counterattack evaluation loop — wired up in Phase A5
		if (_value) then {
			["setSector", format ["counterattack flagged active on sector '%1'.", _sectorID]] call OSF_fnc_log;
		};
	};

	    // All other fields (militia, hbqModules, commandPoints, etc.) have no side effects
};