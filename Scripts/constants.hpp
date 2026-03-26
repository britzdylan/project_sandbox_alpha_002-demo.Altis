// ============================================================
// scripts/constants.hpp
// Compile-time string constants for all hashmap and namespace keys.
// #include this file at the top of any .sqf that references these keys.
//
// Usage:
//   #include "..\..\scripts\constants.hpp"
// ============================================================

// ------------------------------------------------------------
// Mission namespace variable names
// Used with OSF_fnc_getMissionVar / OSF_fnc_setMissionVar
// ------------------------------------------------------------
#define OSF_KEY_DEBUG           "OSF_debug"
#define OSF_KEY_OP_FAILURES     "OSF_operationFailures"
#define OSF_KEY_CAMPAIGN_PHASE  "OSF_campaignPhase"
#define OSF_KEY_ASSET_INVENTORY "OSF_assetInventory"
#define OSF_KEY_ODA_ROSTER      "OSF_odaRoster"
#define OSF_KEY_SECTOR_STATE    "OSF_sectorState"
#define OSF_KEY_TOC_STATE       "OSF_tocState"
#define OSF_KEY_UPGRADE_STATE   "OSF_upgradeState"
#define OSF_KEY_UPGRADE_DEFS    "OSF_upgradeDefs"
#define OSF_KEY_CP_POINTS       "OSF_cpPoints"
#define OSF_KEY_PENDING_LOADOUT "OSF_pendingPlayerLoadout"
#define OSF_KEY_TUTORIAL_COMPLETE "OSF_tutorialComplete"
#define OSF_KEY_TASK_STATES     "OSF_taskStates"
#define OSF_KEY_TASK_REGISTRY   "OSF_taskRegistry"

// ------------------------------------------------------------
// PROFILE namespace variable names
// Used with OSF_fnc_getProfileVar / OSF_fnc_setProfileVar
// ------------------------------------------------------------
#define OSF_PROFILE_SAVE_DATA      "OSF_saveData"
#define OSF_PROFILE_SAVE_EXISTS    "OSF_saveExists"

// Save schema version — increment when save format changes
#define OSF_SAVE_VERSION  1

// ------------------------------------------------------------
// Player constants
// Keys used inside for the player
// ------------------------------------------------------------
#define OSF_START_POS              [2977.05,21475.4,9.53674e-07]
#define OSF_TOC_SPAWN_POS_001      [5193.56,21284.2,0]


// ------------------------------------------------------------
// TOC entry field names
// Keys used inside individual TOC state hashmaps
// ------------------------------------------------------------
#define OSF_TOC_ID              "id"
#define OSF_TOC_POS             "pos"
#define OSF_TOC_STRATEGIC_MISSION   "strategicMapMission"
#define OSF_TOC_STRATEGIC_OBJ_ID    "strategicMapObjectId"
#define OSF_TOC_SQUAD_MANAGER_OBJ_ID    "squadManagerObjectId"
#define OSF_TOC_FIA_MANAGER_OBJ_ID  "fiaManagerObjectId"
#define OSF_TOC_FLAG_OBJ_ID "flagGameManagerObjectId"

// ------------------------------------------------------------
// ODA member field names
// Keys used inside individual ODA slot hashmaps
// ------------------------------------------------------------
#define OSF_ODA_SLOT_ID             "slotId"
#define OSF_ODA_RANK                "rank"
#define OSF_ODA_ROLE                "role"
#define OSF_ODA_MOS                 "mos"
#define OSF_ODA_PASSIVE_BONUS       "passiveBonus"
#define OSF_ODA_UNIT_CLASS          "unitClass"
#define OSF_ODA_LOADOUT             "loadout"
#define OSF_ODA_STATUS              "status"
#define OSF_ODA_IN_SQUAD            "inSquad"
#define OSF_ODA_IDENTITY_CLASS      "identityClass"
#define OSF_ODA_UNIT_REF            "unitRef"
#define OSF_ODA_INCAPACITATED_TIMER "incapacitatedTimer"
#define OSF_ODA_REPLACEMENT_TIMER   "replacementTimer"

// ------------------------------------------------------------
// Vehicle drop
// ------------------------------------------------------------
#define OSF_KEY_LAST_VEHICLE_DROP  "OSF_lastVehicleDrop"
#define OSF_VEHICLE_DROP_COOLDOWN  4   // in-game days between drops
#define OSF_VEHICLE_DROP_SKIP_TIME 12  // hours to skip on drop

// ------------------------------------------------------------
// World settings
// ------------------------------------------------------------
#define OSF_TIME_MULTIPLIER  (24 / 4)   // 6x — matches setTimeMultiplier in fn_boot
#define OSF_WEATHER_INTERVAL   1800     // seconds between weather transitions (30 min)(1800)
#define OSF_WEATHER_TRANSITION 300    // seconds for weather to smoothly transition (5 min)(300)
// ------------------------------------------------------------
// ODA timers (mission seconds)
// Alpha: short values for testing.
// Production: OSF_REPLACEMENT_DURATION = 21600, OSF_INCAP_DURATION = 30 * 60
// ------------------------------------------------------------
#define OSF_REPLACEMENT_DURATION  21600  // 2 min testing | production: 21600
#define OSF_INCAP_DURATION        3   // 1 min testing | production: 1800
#define OSF_REVIVE_DURATION_MEDIC 30   // medic with medkit (testing) | production: 30
#define OSF_REVIVE_DURATION_PLAYER 120  // player with medkit (testing) | production: 120

// Unit variable key — set directly on the object at spawn/incap time
#define OSF_ODA_INCAPACITATED     "OSF_incapacitated"
#define OSF_REVIVE_ACTION_ID      "OSF_reviveActionId"
#define OSF_REVIVE_IN_PROGRESS    "OSF_reviveInProgress"

// ------------------------------------------------------------
// Log verbosity levels
// Used as 3rd param to OSF_fnc_log
// ------------------------------------------------------------
#define OSF_LOG_ERROR    1
#define OSF_LOG_WARN     2
#define OSF_LOG_INFO     3
#define OSF_LOG_VERBOSE  4

// ------------------------------------------------------------
// CBA event names
// Fired via [eventName, params] call CBA_fnc_localEvent
// Listened via [eventName, handler] call CBA_fnc_addEventHandler
// ------------------------------------------------------------
#define OSF_EVT_SECTOR_LIBERATED    "OSF_evt_sectorLiberated"
#define OSF_EVT_SECTOR_LOST         "OSF_evt_sectorLost"
#define OSF_EVT_CP_CHANGED          "OSF_evt_cpChanged"
#define OSF_EVT_OPERATION_COMPLETE  "OSF_evt_operationComplete"
#define OSF_EVT_OPERATION_FAILED    "OSF_evt_operationFailed"
#define OSF_EVT_QUEST_STATE_CHANGED "OSF_evt_questStateChanged"

// ------------------------------------------------------------
// ODA member status values
// Used with OSF_ODA_STATUS field
// ------------------------------------------------------------
#define OSF_ODA_STATUS_ACTIVE           "active"
#define OSF_ODA_STATUS_INACTIVE         "inactive"
#define OSF_ODA_STATUS_INCAP            "incapacitated"
#define OSF_ODA_STATUS_RR               "r&r"
#define OSF_ODA_STATUS_KIA              "kia"
#define OSF_ODA_STATUS_REDEPLOYMENT     "redeployment_in_progress"
