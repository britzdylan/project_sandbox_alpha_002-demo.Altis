// ============================================================
// OSF_fnc_tocMilitiaUI
// Opens the FIA Upgrade Command dialog with full logic:
//   - Purchases are tentative until Save is clicked
//   - Save  : persists upgrade state to profileNamespace
//   - Close : rolls back missionNamespace to pre-dialog snapshot
//   - Escape: same rollback via Unload event handler
//
// Snapshot is serialised as an array (not a hashmap reference)
// so it survives the dialog lifecycle safely.
//
// params: none
// returns: nothing
// ============================================================

#include "..\..\scripts\constants.hpp"

params [];

createDialog "OSF_UpgradeUI";
waitUntil { !isNull (findDisplay 9002) };

private _display = findDisplay 9002;

// IDC -> nodeId lookup (mirrors upgradeUI.hpp IDC assignments)
private _nodeMap = [
    [9410, "upgrade_support_ammo"],
    [9411, "upgrade_support_transport"],
    [9412, "upgrade_support_qrf"],
    [9413, "upgrade_support_mortar"],
    [9420, "upgrade_cap_smallarms"],
    [9421, "upgrade_cap_supportweapons"],
    [9422, "upgrade_cap_technicals"],
    [9423, "upgrade_cap_heavyvehicles"],
    [9430, "upgrade_int_fob"],
    [9431, "upgrade_int_aob"],
    [9432, "upgrade_int_farp"],
    [9433, "upgrade_int_carrier"],
    [9440, "upgrade_def_roadblocks"],
    [9441, "upgrade_def_roadpatrols"],
    [9442, "upgrade_def_atdefence"],
    [9443, "upgrade_def_airdefence"]
];

_display setVariable ["OSF_nodeMap", _nodeMap];

// ── Snapshot pre-dialog state ────────────────────────────────
// Serialised as an array so we hold a copy, not a reference.
private _upgradeMap     = [OSF_KEY_UPGRADE_STATE] call OSF_fnc_getMissionVar;
private _snapshotUpgrade = [];
{ _snapshotUpgrade pushBack [_x, _upgradeMap get _x]; } forEach (keys _upgradeMap);
private _snapshotCP = [OSF_KEY_CP_POINTS] call OSF_fnc_getMissionVar;

_display setVariable ["OSF_snapshot",  [_snapshotUpgrade, _snapshotCP]];
_display setVariable ["OSF_saved",     false];

// ── Refresh ──────────────────────────────────────────────────
// Recolors all buttons and updates CP counter.
// Self-contained — safe to call from event handler scope.
private _fnRefresh = {
    params ["_display"];

    private _nodeMap = _display getVariable ["OSF_nodeMap", []];

    private _bgPurchased  = [0.06, 0.22, 0.06, 1.0];
    private _txtPurchased = [0.35, 0.85, 0.35, 1.0];
    private _bgAvailable  = [0.10, 0.16, 0.08, 1.0];
    private _txtAvailable = [0.72, 0.88, 0.55, 1.0];
    private _bgLocked     = [0.06, 0.08, 0.06, 1.0];
    private _txtLocked    = [0.30, 0.36, 0.26, 1.0];

    private _cp = [OSF_KEY_CP_POINTS] call OSF_fnc_getMissionVar;
    (_display displayCtrl 9400) ctrlSetText format ["COMMAND POINTS: %1", _cp];

    {
        private _idc    = _x select 0;
        private _nodeId = _x select 1;
        private _btn    = _display displayCtrl _idc;

        if ([_nodeId] call OSF_fnc_upgradeHasNode) then {
            _btn ctrlSetBackgroundColor _bgPurchased;
            _btn ctrlSetTextColor _txtPurchased;
        } else {
            if (([_nodeId] call OSF_fnc_upgradeCanPurchase) select 0) then {
                _btn ctrlSetBackgroundColor _bgAvailable;
                _btn ctrlSetTextColor _txtAvailable;
            } else {
                _btn ctrlSetBackgroundColor _bgLocked;
                _btn ctrlSetTextColor _txtLocked;
            };
        };
    } forEach _nodeMap;
};

_display setVariable ["OSF_refresh", _fnRefresh];

// ── Unload — rollback if not saved ───────────────────────────
_display displayAddEventHandler ["Unload", {
    params ["_display"];
    if (_display getVariable ["OSF_saved", false]) exitWith {};

    // Restore snapshot to missionNamespace
    private _snapshot       = _display getVariable ["OSF_snapshot", [[], 0]];
    private _snapshotUpgrade = _snapshot select 0;
    private _snapshotCP      = _snapshot select 1;

    private _restoredMap = createHashMap;
    { _restoredMap set [_x select 0, _x select 1]; } forEach _snapshotUpgrade;

    [OSF_KEY_UPGRADE_STATE, _restoredMap] call OSF_fnc_setMissionVar;
    [OSF_KEY_CP_POINTS,     _snapshotCP]  call OSF_fnc_setMissionVar;
}];

// ── Initial render ───────────────────────────────────────────
[_display] call _fnRefresh;

// ── Node event handlers ───────────────────────────────────────
{
    private _idc    = _x select 0;
    private _nodeId = _x select 1;
    private _btn    = _display displayCtrl _idc;

    _btn setVariable ["OSF_nodeId", _nodeId];

    // MouseEnter: show node info + status in description panel
    _btn ctrlAddEventHandler ["MouseEnter", {
        params ["_ctrl"];
        private _display = ctrlParent _ctrl;
        private _nodeId  = _ctrl getVariable ["OSF_nodeId", ""];
        private _nodeDef = ([OSF_KEY_UPGRADE_DEFS] call OSF_fnc_getMissionVar) get _nodeId;
        if (isNil "_nodeDef") exitWith {};

        private _name = _nodeDef select 1;
        private _desc = _nodeDef select 2;
        private _cost = _nodeDef select 3;

        private _status = if ([_nodeId] call OSF_fnc_upgradeHasNode) then {
            "ACQUIRED"
        } else {
            private _check = [_nodeId] call OSF_fnc_upgradeCanPurchase;
            if (_check select 0) then {
                format ["Available - %1 CP", _cost]
            } else {
                _check select 1
            }
        };

        (_display displayCtrl 9401) ctrlSetText format ["%1  |  %2  |  %3", _name, _status, _desc];
    }];

    // ButtonClick: attempt purchase, refresh on success
    _btn ctrlAddEventHandler ["ButtonClick", {
        params ["_ctrl"];
        private _display  = ctrlParent _ctrl;
        private _nodeId   = _ctrl getVariable ["OSF_nodeId", ""];
        private _nodeDef  = ([OSF_KEY_UPGRADE_DEFS] call OSF_fnc_getMissionVar) get _nodeId;
        if (isNil "_nodeDef") exitWith {};

        private _name     = _nodeDef select 1;
        private _desc     = _nodeDef select 2;
        private _descCtrl = _display displayCtrl 9401;

        if ([_nodeId] call OSF_fnc_upgradeHasNode) exitWith {
            _descCtrl ctrlSetText format ["%1  |  Already acquired.  |  %2", _name, _desc];
        };

        private _check = [_nodeId] call OSF_fnc_upgradeCanPurchase;
        if !(_check select 0) exitWith {
            _descCtrl ctrlSetText format ["%1  |  %2", _name, _check select 1];
        };

        [_nodeId] call OSF_fnc_upgradePurchase;
        _descCtrl ctrlSetText format ["%1  |  Acquired.  |  %2", _name, _desc];
        [_display] call (_display getVariable ["OSF_refresh", {}]);
    }];

} forEach _nodeMap;

// ── Save button ───────────────────────────────────────────────
// Persists upgrade state to profileNamespace and marks as saved
// so the Unload handler skips the rollback.
(_display displayCtrl 9403) ctrlAddEventHandler ["ButtonClick", {
    params ["_ctrl"];
    private _display = ctrlParent _ctrl;

    private _upgradeMap = [OSF_KEY_UPGRADE_STATE] call OSF_fnc_getMissionVar;
    private _upgradeArr = [];
    { _upgradeArr pushBack [_x, _upgradeMap get _x]; } forEach (keys _upgradeMap);

    ["OSF_SAVE_upgradeState", _upgradeArr] call OSF_fnc_setProfileVar;
    ["OSF_SAVE_cpPoints", ([OSF_KEY_CP_POINTS] call OSF_fnc_getMissionVar)] call OSF_fnc_setProfileVar;
    saveProfileNamespace;

    _display setVariable ["OSF_saved", true];
    (_display displayCtrl 9401) ctrlSetText "Upgrades saved.";
}];

// ── Close button ──────────────────────────────────────────────
// Unload handler performs the rollback; we just close.
(_display displayCtrl 9402) ctrlAddEventHandler ["ButtonClick", {
    closeDialog 0;
}];
