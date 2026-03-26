// ============================================================
// init.sqf — Operation Sovereign Fury
// Mission entry point. Runs on every load (fresh and save restore).
// ============================================================
//
// ---- Project Conventions ----
//
// Folder layout:
//   Functions/<domain>/fn_<name>.sqf   — SQF functions, auto-registered via CfgFunctions
//   scripts/data/<domain>Data.sqf      — Static config arrays (sectors, ODA, loadouts, upgrades, TOC)
//   scripts/loadouts/oda_<variant>_<role>.sqf — Preset loadout definitions
//   scripts/constants.hpp              — All #define constants (keys, timers, event names)
//   ui/                                — Dialog .hpp includes (defines.hpp, upgradeUI.hpp, etc.)
//   third-party/                       — External scripts (HBQ, Drongos, action menu)
//   docs/                              — Developer and player guides
//
// Naming:
//   Functions  : OSF_fnc_<name>         (auto from CfgFunctions class OSF)
//   Constants  : OSF_KEY_*              (missionNamespace keys)
//                OSF_PROFILE_*          (profileNamespace keys)
//                OSF_TOC_*, OSF_ODA_*   (hashmap field name keys)
//   Events     : OSF_evt_*              (CBA event names)
//   Globals    : OSF_*                  (all runtime globals carry the OSF_ prefix)
//   Log levels : OSF_LOG_ERROR/WARN/INFO/VERBOSE (1-4)
//
// Boot flow:
//   1. fn_boot phase 1 (world settings, debug flag, log verbosity)
//   2. Wait for player + dependencies
//   3. Startup menu (Continue / New Game)
//   4. fn_boot phase 2 (domain init based on choice)
//   5. Post-init (player loadout restore, HBQ re-registration)
//
// ============================================================
#include "scripts\constants.hpp"
// disable player input
player enableSimulation false;
player allowDamage false;
enableSaving [false, false];

// fade out audio and screen
["start", false] call BIS_fnc_blackOut;

// ---- 1. Boot phase 1 — pre-display setup ----
[] call OSF_fnc_boot;

// ---- 2. Wait for player and dependencies ----
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
dceAvailable = false;

["init", "Player ready.", OSF_LOG_INFO] call OSF_fnc_log;

// ---- 3. Startup menu ----
private _choice = [] call OSF_fnc_startupMenu;

// ---- 4. Boot phase 2 — domain init ----
[_choice] call OSF_fnc_boot;

// ---- 5. Post-init ----

// Apply saved player loadout (if restoring from save)
private _pendingLoadout = missionNamespace getVariable ["OSF_pendingPlayerLoadout", []];
if (count _pendingLoadout > 0) then {
    player setUnitLoadout _pendingLoadout;
    missionNamespace setVariable ["OSF_pendingPlayerLoadout", nil];
    ["init", "Player loadout restored from save.", OSF_LOG_INFO] call OSF_fnc_log;
};

// ---- 6. Player respawn system ----
[] call OSF_fnc_playerRespawn;

// ---- 7. Tutorial or resume ----
if (_choice == "newgame") then {
    [] spawn OSF_fnc_tutorialIntro;
} else {
    ["start"] call BIS_fnc_blackIn;
    3 fadeSound 1;
    // Returning player — skip tutorial
    missionNamespace setVariable ["OSF_tutorialComplete", true];

    // Recreate completed tasks (BIS tasks don't persist across mission loads)
    [
        true,
        ["task_establish_toc"],
        ["Establish your Tactical Operations Center at the marked position. This will be your base of operations.", "Establish TOC", "TOC"],
        nil,
        "SUCCEEDED",
        -1,
        false,
        "navigate"
    ] call BIS_fnc_taskCreate;

    hint "Welcome back, Team Lead.";
    [] spawn { sleep 4; hintSilent ""; };
};

player enableSimulation true;
player allowDamage true;

["init", "init.sqf complete.", OSF_LOG_INFO] call OSF_fnc_log;
