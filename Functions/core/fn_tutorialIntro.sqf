// ============================================================
// OSF_fnc_tutorialIntro
// Tutorial intro sequence for new games. Guides the player
// from their start position to the TOC with text hints.
// 
// Skipped on save restore (player already knows the TOC).
// 
// Flow:
//   1. Brief radio message setting the scene
//   2. text hints for basic controls (non-blocking)
//   3. Task marker guiding player to TOC
//   4. On arrival at TOC → establish TOC, core loop begins
// 
// params: none
// Returns: nothing (runs as spawned script)
// Usage:  [] spawn OSF_fnc_tutorialIntro;
// ============================================================

#include "..\..\scripts\constants.hpp"

["core", "Tutorial intro starting...", OSF_LOG_INFO] call OSF_fnc_log;

// ---- get TOC position ----
private _tocReg = [OSF_KEY_TOC_STATE, createHashMap] call OSF_fnc_getMissionVar;
private _tocPos = [0, 0, 0];
private _tocId = "";
{
	_tocId = _x;
	_tocPos = _y getOrDefault [OSF_TOC_POS, [0, 0, 0]];
} forEach _tocReg;
private _text = ["ALTIS, 2020s\nOperation Sovereign Fury"] call OSF_fnc_titleText;
// ---- Scene-setting text ----
sleep 2;
titleText [_text, "PLAIN", 0.5, true, true];
sleep 3;
["start"] call BIS_fnc_blackIn;
3 fadeSound 1;
// re-enable player input
sleep 2;

// ---- Radio message ----
[player, "RadioProtocolBATTLE"] remoteExec ["setSpeaker"];
player sideChat "Team lead, this is Aegis Actual. Proceed to the rally point and establish your TOC. How copy?";
sleep 4;

// ---- Movement hint ----
hint "Use WASD to move. Hold SHIFT to sprint.\nPress M to open your map.";
sleep 8;
hintSilent "";

// ---- Squad command hint ----
hint "Your ODA is with you. Use the action menu\n for squad commands.";
sleep 8;
hintSilent "";

// ---- Create task pointing to TOC ----
private _taskId = "task_establish_toc";
[
	true,
	[_taskId],
	["Establish your Tactical Operations Center at the marked position. This will be your base of operations.", "Establish TOC", "TOC"],
	_tocPos,
	"CREATED",
	-1,
	true,
	"navigate"
] call BIS_fnc_taskCreate;

hint "Follow the objective marker to establish your TOC.";
sleep 6;
hintSilent "";

// ---- Wait for player to reach TOC ----
waitUntil {
	sleep 1;
	player distance2D _tocPos < 30
};

// ---- Establish TOC ----
[_taskId, "SUCCEEDED"] call BIS_fnc_taskSetState;
sleep 1;

titleText ["TOC ESTABLISHED\nAccess the strategic map, squad manager, and upgrades here.", "PLAIN", 1];
sleep 4;
titleText ["", "PLAIN"];

// Combat hint
hint "Tip: When wounded, your medic can auto-revive nearby teammates.\nUse Ctrl+F12 to toggle the debug overlay.";
sleep 8;
hintSilent "";

// Mark tutorial as complete
missionNamespace setVariable ["OSF_tutorialComplete", true];

["core", "Tutorial intro complete. TOC established.", OSF_LOG_INFO] call OSF_fnc_log;