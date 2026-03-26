// ============================================================
// OSF_fnc_startupMenu
// Shows a "Press SPACE to launch" prompt, then opens the startup
// menu dialog. If the player closes the dialog with Escape (no
// choice made), the prompt reappears and the cycle repeats.
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

// ---- Loop: show prompt → open dialog → repeat if escaped ----
while { missionNamespace getVariable ["OSF_startupChoice", ""] == "" } do {

    // Show "Press SPACE to launch" prompt
    titleText [
        (["PRESS SPACE TO LAUNCH", 1.6, "#9ece6a"] call OSF_fnc_titleText),
        "PLAIN", -1, true, true
    ];

    // Wait for SPACE key (DIK code 57) via display keyDown EH
    missionNamespace setVariable ["OSF_spacePressed", false];
    private _displayMain = findDisplay 46;
    private _ehIdx = _displayMain displayAddEventHandler ["KeyDown", {
        params ["_display", "_key"];
        if (_key == 57) then {
            missionNamespace setVariable ["OSF_spacePressed", true];
            true // consume the key
        } else {
            false
        };
    }];

    waitUntil { missionNamespace getVariable ["OSF_spacePressed", false] };

    _displayMain displayRemoveEventHandler ["KeyDown", _ehIdx];
    missionNamespace setVariable ["OSF_spacePressed", nil];

    // Clear the prompt
    titleText ["", "PLAIN"];

    // Open dialog
    createDialog "OSF_StartupMenu";

    private _display = findDisplay 9003;
    if (isNull _display) then {
        ["boot", "Failed to open startup menu dialog.", OSF_LOG_ERROR] call OSF_fnc_log;
        missionNamespace setVariable ["OSF_startupChoice", "newgame"];
    } else {

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

        // Wait until dialog is closed (either by button or Escape)
        waitUntil { isNull findDisplay 9003 };

        // If closed without a choice (Escape), loop will repeat
    };
};

private _choice = missionNamespace getVariable ["OSF_startupChoice", "newgame"];
["boot", format ["Startup menu choice: %1", _choice], OSF_LOG_INFO] call OSF_fnc_log;

_choice
