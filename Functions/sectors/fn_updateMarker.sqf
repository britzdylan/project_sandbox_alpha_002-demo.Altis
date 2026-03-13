// ============================================================
// OSF_fnc_updateMarker
// Syncs the Eden area marker color for a sector to its current status.
// Called automatically by fn_setSector when "status" field changes.
// 
// params: [sectorID (string)]
// Returns: nothing
// Usage:  ["sector_tutorial"] call OSF_fnc_updateMarker;
// ============================================================

#include "..\..\scripts\constants.hpp"

params ["_sectorID"];

private _registry = [OSF_KEY_SECTOR_STATE, createHashMap] call OSF_fnc_getMissionVar;
private _sectorMap = _registry getOrDefault [_sectorID, createHashMap];

private _markerName = _sectorMap getOrDefault ["boundaryMarker", ""];
private _status = _sectorMap getOrDefault ["status", "occupied"];

if (_markerName == "") exitWith {
	["updateMarker", format ["no boundaryMarker defined for sector %1", _sectorID]] call OSF_fnc_log;
};

private _color = switch (_status) do {
	case "occupied": {
		"ColorRed"
	};
	case "contested": {
		"ColorYellow"
	};
	case "liberated": {
		"ColorGreen"
	};
	default {
		"ColorBlue"
	};
};

_markerName setMarkerColorLocal _color;
_markerName setMarkerAlphaLocal 0.5;