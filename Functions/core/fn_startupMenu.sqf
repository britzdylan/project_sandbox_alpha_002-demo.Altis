// ============================================================
// OSF_fnc_startupMenu
// Shows the startup menu dialog. Player chooses Continue or New Game.
// Blocks execution until a choice is made via OSF_startupChoice.
//
// If no save exists, the Continue button is greyed out.
//
// Params: none
// Returns: "continue" or "newgame" (string)
// Usage:  private _choice = [] call OSF_fnc_startupMenu;
// ============================================================

#include "..\..\scripts\constants.hpp"

params [];

// Reset choice flag
missionNamespace setVariable ["OSF_startupChoice", ""];

// Check for existing save
private _saveExists = [OSF_PROFILE_SAVE_EXISTS, false] call OSF_fnc_getProfileVar;

// Open dialog
createDialog "OSF_StartupMenu";

private _display = findDisplay 9003;
if (isNull _display) exitWith {
    ["boot", "Failed to open startup menu dialog.", OSF_LOG_ERROR] call OSF_fnc_log;
    "newgame"
};

// ---- Wire Continue button ----
private _btnContinue = _display displayCtrl 9502;
private _btnNewGame = _display displayCtrl 9503;
private _lblStatus = _display displayCtrl 9504;

if (_saveExists) then {
    _lblStatus ctrlSetText "Save data found.";

    _btnContinue ctrlAddEventHandler ["ButtonClick", {
        missionNamespace setVariable ["OSF_startupChoice", "continue"];
        closeDialog 0;
    }];
} else {
    _lblStatus ctrlSetText "No save data.";

    // Grey out continue button
    _btnContinue ctrlEnable false;
    _btnContinue ctrlSetTextColor [0.4, 0.4, 0.4, 0.5];
    _btnContinue ctrlSetBackgroundColor [0.08, 0.08, 0.08, 0.6];
};

// ---- Wire New Game button ----
_btnNewGame ctrlAddEventHandler ["ButtonClick", {
    missionNamespace setVariable ["OSF_startupChoice", "newgame"];
    closeDialog 0;
}];

// ---- Block until choice is made ----
waitUntil { missionNamespace getVariable ["OSF_startupChoice", ""] != "" };

private _choice = missionNamespace getVariable ["OSF_startupChoice", "newgame"];
["boot", format ["Startup menu choice: %1", _choice], OSF_LOG_INFO] call OSF_fnc_log;

_choice
