/*
	Function:    fn_vehicleDrop
	Description: Requests a vehicle drop at the TOC. One of 4 vehicle types selected
	             by index. Subject to a 4 in-game-day cooldown. Spawns the vehicle at
	             a fixed pad near the TOC, then advances time by 12 hours via fn_skipTime.
	Parameters:  _typeIndex (Number) — 0: Offroad, 1: Armed Offroad, 2: MRAP Hunter, 3: Transport Truck
	Use when:    Requesting vehicle resupply from the SUPPORT or MISC menu.
*/
#include "..\..\scripts\constants.hpp"
params [["_typeIndex", -1, [0]]];

private _vehicleTypes = [
	["B_G_Offroad_01_armor_AT_lxWS", "AT Offroad UP"],
	["B_G_Offroad_01_armor_armed_lxWS", "HMG Offroad UP"],
	["B_G_Offroad_01_armor_base_lxWS", "Offroad UP"]
];

// randomise if no selection passed
if (_typeIndex < 0) then {
	_typeIndex = floor random (count _vehicleTypes);
};

if (_typeIndex >= count _vehicleTypes) exitWith {
	["Invalid vehicle type.", "error"] call OSF_fnc_notify;
};

// ---- cooldown check ----
private _now = dateToNumber date;
private _lastDrop = missionNamespace getVariable [OSF_KEY_LAST_VEHICLE_DROP, -1];

if (_lastDrop > 0 && {
	(_now - _lastDrop) < (OSF_VEHICLE_DROP_COOLDOWN / 365)
}) then {
	private _remaining = (OSF_VEHICLE_DROP_COOLDOWN / 365) - (_now - _lastDrop);
	private _remainHours = round (_remaining * 365 * 24);
	[format ["Vehicle drop unavailable. Next drop in ~%1h.", _remainHours], "warning"] call OSF_fnc_notify;
} else {
	// ---- drop pad: relPos from player ----
	private _dropPos = player getRelPos [15, 0];

	private _entry = _vehicleTypes select _typeIndex;
	private _className = _entry select 0;
	private _displayName = _entry select 1;

	// skip time (handles fade, player disable, etc.)
	[OSF_VEHICLE_DROP_SKIP_TIME] call OSF_fnc_skipTime;

	// spawn vehicle at drop pad
	private _vehicle = createVehicle [_className, _dropPos, [], 0, "NONE"];
	_vehicle setPos _dropPos;
	_vehicle setDir 90;

	// record drop time
	missionNamespace setVariable [OSF_KEY_LAST_VEHICLE_DROP, dateToNumber date];

	[format ["%1 has been delivered to the TOC.", _displayName], "success"] call OSF_fnc_notify;
};