// ============================================================
// OSF_fnc_tocSquadUI
// Opens the squad management dialog (if not already open) and
// populates / refreshes the ODA roster and stats bar.
// Event handlers are wired once on initial open; subsequent
// calls (from button actions) only refresh the list in-place.
//
// params: none
// Returns: nothing
// Usage: [] call OSF_fnc_tocSquadUI;
// ============================================================
#include "..\..\scripts\constants.hpp"

private _display = findDisplay 9001;
private _isOpen = !isNull _display;

if (!_isOpen) then {
	createDialog "OSF_SquadUI";
	_display = findDisplay 9001;
};

// Clear listbox (removes all rows including previous header)
lnbClear 9100;

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
private _roster = missionNamespace getVariable OSF_KEY_ODA_ROSTER;
private _loadoutDefs = call compile preProcessFileLineNumbers "scripts\data\loadoutData.sqf";
private _rowIdx = 1; // row 0 = header

// Status counters for the stats bar
private _cntActive      = 0;
private _cntInactive    = 0;
private _cntRR          = 0;
private _cntKIA         = 0;
private _cntRedeployment= 0;

{
	private _slot = _y;
	private _status  = _slot get OSF_ODA_STATUS;
	private _inSquad = _slot get OSF_ODA_IN_SQUAD;

	private _statusLabel = _statusLabels getOrDefault [_status, toUpper _status];
	private _statusColor = _statusColors getOrDefault [_status, [0.9, 0.9, 0.9, 1.0]];

	private _loadoutId   = _slot getOrDefault [OSF_ODA_LOADOUT, ""];
	private _mos         = _slot getOrDefault [OSF_ODA_MOS, ""];
	private _mosDefs     = _loadoutDefs getOrDefault [_mos, []];
	private _defEntry    = _mosDefs findIf { (_x select 0) == _loadoutId };
	private _loadoutLabel = if (_defEntry >= 0) then { (_mosDefs select _defEntry) select 1 } else { _loadoutId };

	lnbAddRow [9100, [
		_slot get OSF_ODA_RANK,
		_slot get OSF_ODA_ROLE,
		_slot get OSF_ODA_MOS,
		_statusLabel,
		if (_inSquad) then {"YES"} else {"NO"},
		_loadoutLabel
	]];

	// Store slotId as hidden data on col 0 — used by action handlers
	lnbSetData [9100, [_rowIdx, 0], _slot get OSF_ODA_SLOT_ID];

	lnbSetColor [9100, [_rowIdx, 3], _statusColor];
	lnbSetColor [9100, [_rowIdx, 4],
		if (_inSquad) then {[0.35, 0.85, 0.35, 1.0]} else {[0.70, 0.70, 0.70, 1.0]}
	];

	// Tally for stats bar
	switch (_status) do {
		case OSF_ODA_STATUS_ACTIVE:      { _cntActive       = _cntActive       + 1 };
		case OSF_ODA_STATUS_INACTIVE:    { _cntInactive     = _cntInactive     + 1 };
		case OSF_ODA_STATUS_RR:          { _cntRR           = _cntRR           + 1 };
		case OSF_ODA_STATUS_KIA:         { _cntKIA          = _cntKIA          + 1 };
		case OSF_ODA_STATUS_REDEPLOYMENT:{ _cntRedeployment = _cntRedeployment + 1 };
	};

	_rowIdx = _rowIdx + 1;
} forEach _roster;

["tocSquadUI", format ["%1 slot(s) displayed.", count (keys _roster)]] call OSF_fnc_log;

// --- Populate stats bar ---
(_display displayCtrl 9300) ctrlSetText format [
	"DEPLOYED: %1    STANDBY: %2    R&R: %3    KIA: %4    INBOUND: %5",
	_cntActive, _cntInactive, _cntRR, _cntKIA, _cntRedeployment
];

// Buttons reset to disabled after every refresh (selection is cleared by lnbClear)
(_display displayCtrl 9201) ctrlEnable false;
(_display displayCtrl 9202) ctrlEnable false;
(_display displayCtrl 9203) ctrlEnable false;

// ============================================================
// Event handlers — wired once on initial open only
// ============================================================
lbClear 9203;

if (_isOpen) exitWith {};

// --- Row selection: enable buttons and sync combo to selected slot and populates loadouts ---
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
	private _slot = [OSF_KEY_ODA_ROSTER, _slotId] call OSF_fnc_getState;
	if (isNil "_slot") exitWith {};
	private _status = _slot getOrDefault [OSF_ODA_STATUS, ""];

	// Deploy: only available from standby
	(_display displayCtrl 9201) ctrlEnable (_status == OSF_ODA_STATUS_INACTIVE);
	// Dismiss: only available when active
	(_display displayCtrl 9202) ctrlEnable (_status == OSF_ODA_STATUS_ACTIVE);
	// Loadout combo: available when active or standby
	(_display displayCtrl 9203) ctrlEnable (_status in [OSF_ODA_STATUS_ACTIVE, OSF_ODA_STATUS_INACTIVE]);

	// Populate combo with loadouts available for this slot's MOS
	private _mos = _slot getOrDefault [OSF_ODA_MOS, ""];
	private _loadoutDefs = call compile preProcessFileLineNumbers "scripts\data\loadoutData.sqf";
	private _available = _loadoutDefs getOrDefault [_mos, []];

	lbClear 9203;
	{ (_display displayCtrl 9203) lbAdd (_x select 1); } forEach _available;
	{ (_display displayCtrl 9203) lbSetData [_forEachIndex, (_x select 0)]; } forEach _available;

	// Disable combo if no loadouts defined for this MOS yet
	(_display displayCtrl 9203) ctrlEnable (
		(_status in [OSF_ODA_STATUS_ACTIVE, OSF_ODA_STATUS_INACTIVE]) && count _available > 0
	);

	// Pre-select the slot's current loadout
	private _current = _slot getOrDefault [OSF_ODA_LOADOUT, ""];
	private _currentIdx = _available findIf { (_x select 0) == _current };
	(_display displayCtrl 9203) lbSetCurSel (if (_currentIdx >= 0) then {_currentIdx} else {0});
}];

// --- DEPLOY button ---
(_display displayCtrl 9201) ctrlAddEventHandler ["ButtonClick", {
	private _row = lnbCurSelRow 9100;
	if (_row <= 0) exitWith {};
	private _slotId = lnbData [9100, [_row, 0]];
	[_slotId] call OSF_fnc_odaSpawn;
	lnbSetCurSelRow [9100, -1];
	[] call OSF_fnc_tocSquadUI;
}];

// --- DISMISS button ---
(_display displayCtrl 9202) ctrlAddEventHandler ["ButtonClick", {
	private _row = lnbCurSelRow 9100;
	if (_row <= 0) exitWith {};
	private _slotId = lnbData [9100, [_row, 0]];
	[_slotId] call OSF_fnc_odaDismiss;
	lnbSetCurSelRow [9100, -1];
	[] call OSF_fnc_tocSquadUI;
}];

// --- LOADOUT combo: apply selection immediately on change ---
// Actual re-equipping applied when loadout system is built.
(_display displayCtrl 9203) ctrlAddEventHandler ["LBSelChanged", {
	params ["_ctrl", "_idx"];
	private _row = lnbCurSelRow 9100;
	if (_row <= 0) exitWith {};

	// ID was stored on each combo item via lbSetData when the row was selected
	private _loadoutId = lbData [9203, _idx];
	if (_loadoutId == "") exitWith {};

	private _slotId = lnbData [9100, [_row, 0]];
	[_slotId, _loadoutId] call OSF_fnc_odaApplyLoadout;

	lnbSetText [9100, [_row, 5], lbText [9203, _idx]];
}];
