// ============================================================
// init.sqf — Operation Sovereign Fury
// Mission entry point. Runs on every load (fresh and save restore).
// ============================================================
#include "scripts\constants.hpp"

// ---- 1. Boot game state ----
// Builds or restores the sector hashmap, initializes global vars,
// and updates all map markers. Must run before anything else.
[] call OSF_fnc_boot;
// ---- 2. Register HBQ module object references ----
// Eden-placed HBQ modules are referenced by their editor variable names.
// These refs must be re-registered every load (object refs can't be persisted).
// Add your HBQ module variable names here once placed in Eden.
// 
// Example (replace hbqModule_tutorial_1 etc. with your actual Eden variable names):
// ["sector_tutorial", "hbqModules", [hbqModule_tutorial_1, hbqModule_tutorial_2]]
//     call OSF_fnc_setSector;

// ---- 3. System init stubs (uncomment as each phase is built) ----

// Phase A2 — ODA squad system
// [] call OSF_fnc_odaInit;

// Phase A2 — TOC interactions
// [] call OSF_fnc_tocInit;

// Phase A4 — Militia system
// [] call OSF_fnc_militiaInit;

// Phase A5 — Counterattack evaluation loop
// [] spawn OSF_fnc_caEvaluate;

// ---- 4. Debug output ----
// Remove before release. Confirms boot sequence ran and state is readable.
["init", "init.sqf complete."] call OSF_fnc_log;
["init", format ["Tutorial sector status: %1", [OSF_KEY_SECTOR_STATE, "sector_tutorial", "status"] call OSF_fnc_getStateField]] call OSF_fnc_log;

waitUntil {
	!isNull player && {
		alive player
	} && {
		player == player
	} && {
		!isNil "dceReady" && {
			dceReady
		}
	}
};
dceAvailable=false;

hint format ["[OSF] Tutorial sector status: %1", [OSF_KEY_SECTOR_STATE, "sector_tutorial", "status"] call OSF_fnc_getStateField];