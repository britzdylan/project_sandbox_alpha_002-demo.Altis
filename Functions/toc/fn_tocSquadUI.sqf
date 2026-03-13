// ============================================================
// OSF_fnc_tocSquadUI
// Opens the squad management dialog, populates the ODA roster,
// and wires selection-aware action buttons.
//
// params: none
// Returns: nothing
// Usage: [] call OSF_fnc_tocSquadUI;
// ============================================================
#include "..\..\scripts\constants.hpp"

createDialog "OSF_SquadUI";

// --- Header row ---
lnbAddRow [9100, ["RANK", "ROLE", "MOS", "STATUS", "IN SQUAD", "LOADOUT"]];
for "_i" from 0 to 5 do {
	lnbSetColor [9100, [0, _i], [0.95, 0.82, 0.35, 1.0]];
};

// --- Status display labels and colors ---
private _statusLabels = createHashMapFromArray [
	[OSF_ODA_STATUS_ACTIVE,      "ACTIVE"],
	[OSF_ODA_STATUS_INACTIVE,    "STANDBY"],
	[OSF_ODA_STATUS_RR,          "R&R"],
	[OSF_ODA_STATUS_KIA,         "KIA"],
	[OSF_ODA_STATUS_REDEPLOYMENT,"INBOUND"]
];

private _statusColors = createHashMapFromArray [
	[OSF_ODA_STATUS_ACTIVE,      [0.35, 0.85, 0.35, 1.0]],
	[OSF_ODA_STATUS_INACTIVE,    [0.70, 0.70, 0.70, 1.0]],
	[OSF_ODA_STATUS_RR,          [0.90, 0.75, 0.20, 1.0]],
	[OSF_ODA_STATUS_KIA,         [0.90, 0.25, 0.25, 1.0]],
	[OSF_ODA_STATUS_REDEPLOYMENT,[0.30, 0.75, 0.95, 1.0]]
];

// --- Data rows ---
private _roster = [OSF_KEY_ODA_ROSTER, createHashMap] call OSF_fnc_getMissionVar;
private _rowIdx = 1; // row 0 = header

{
	private _slot = _y;
	private _status  = _slot get OSF_ODA_STATUS;
	private _inSquad = _slot get OSF_ODA_IN_SQUAD;

	private _statusLabel = _statusLabels getOrDefault [_status, toUpper _status];
	private _statusColor = _statusColors getOrDefault [_status, [0.9, 0.9, 0.9, 1.0]];

	lnbAddRow [9100, [
		_slot get OSF_ODA_RANK,
		_slot get OSF_ODA_ROLE,
		_slot get OSF_ODA_MOS,
		_statusLabel,
		if (_inSquad) then {"YES"} else {"NO"},
		_slot get OSF_ODA_LOADOUT
	]];

	// Store slotId as hidden data on col 0 — used by action handlers
	lnbSetData [9100, [_rowIdx, 0], _slot get OSF_ODA_SLOT_ID];

	lnbSetColor [9100, [_rowIdx, 3], _statusColor];
	lnbSetColor [9100, [_rowIdx, 4],
		if (_inSquad) then {[0.35, 0.85, 0.35, 1.0]} else {[0.70, 0.70, 0.70, 1.0]}
	];

	_rowIdx = _rowIdx + 1;
} forEach _roster;

["tocSquadUI", format ["%1 slot(s) displayed.", count (keys _roster)]] call OSF_fnc_log;

// ============================================================
// Event handlers
// ============================================================
private _display = findDisplay 9001;

// Action buttons start disabled — nothing selected yet
(_display displayCtrl 9201) ctrlEnable false;
(_display displayCtrl 9202) ctrlEnable false;
(_display displayCtrl 9203) ctrlEnable false;

// --- Row selection: enable buttons based on selected slot's status ---
(_display displayCtrl 9100) ctrlAddEventHandler ["LBSelChanged", {
	params ["_ctrl", "_row"];
	private _display = ctrlParent _ctrl;

	// Disable all if header or nothing selected
	if (_row <= 0) exitWith {
		(_display displayCtrl 9201) ctrlEnable false;
		(_display displayCtrl 9202) ctrlEnable false;
		(_display displayCtrl 9203) ctrlEnable false;
	};

	private _slotId = lnbData [9100, [_row, 0]];
	private _roster = [OSF_KEY_ODA_ROSTER, createHashMap] call OSF_fnc_getMissionVar;
	private _slot = _roster getOrDefault [_slotId, createHashMap];
	private _status = _slot getOrDefault [OSF_ODA_STATUS, ""];

	// Deploy: only available from standby
	(_display displayCtrl 9201) ctrlEnable (_status == OSF_ODA_STATUS_INACTIVE);
	// Dismiss: only available when active
	(_display displayCtrl 9202) ctrlEnable (_status == OSF_ODA_STATUS_ACTIVE);
	// Change loadout: only available when active
	(_display displayCtrl 9203) ctrlEnable (_status == OSF_ODA_STATUS_ACTIVE);
}];

// --- DEPLOY button ---
(_display displayCtrl 9201) ctrlAddEventHandler ["ButtonClick", {
	private _row = lnbCurSelRow 9100;
	if (_row <= 0) exitWith {};
	private _slotId = lnbData [9100, [_row, 0]];
	// TODO: [_slotId] call OSF_fnc_odaSpawn;
	["tocSquadUI", format ["PLACEHOLDER: deploy %1", _slotId]] call OSF_fnc_log;
}];

// --- DISMISS button ---
(_display displayCtrl 9202) ctrlAddEventHandler ["ButtonClick", {
	private _row = lnbCurSelRow 9100;
	if (_row <= 0) exitWith {};
	private _slotId = lnbData [9100, [_row, 0]];
	// TODO: [_slotId] call OSF_fnc_odaDismiss;
	["tocSquadUI", format ["PLACEHOLDER: dismiss %1", _slotId]] call OSF_fnc_log;
}];

// --- CHANGE LOADOUT button ---
(_display displayCtrl 9203) ctrlAddEventHandler ["ButtonClick", {
	private _row = lnbCurSelRow 9100;
	if (_row <= 0) exitWith {};
	private _slotId = lnbData [9100, [_row, 0]];
	// TODO: [_slotId] call OSF_fnc_odaSetLoadout;
	["tocSquadUI", format ["PLACEHOLDER: change loadout %1", _slotId]] call OSF_fnc_log;
}];
