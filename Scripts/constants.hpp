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

// ------------------------------------------------------------
// PROFILE namespace variable names
// Used with OSF_fnc_getProfileVar / OSF_fnc_setProfileVar
// ------------------------------------------------------------
#define OSF_PROFILE_SECTOR_SAVE    "OSF_sectorSave"
#define OSF_PROFILE_SAVE_EXISTS    "OSF_saveExists"

// ------------------------------------------------------------
// TOC entry field names
// Keys used inside individual TOC state hashmaps
// ------------------------------------------------------------
#define OSF_TOC_ID              "id"
#define OSF_TOC_POS             "pos"
#define OSF_TOC_STRATEGIC_MISSION   "strategicMapMission"
#define OSF_TOC_STRATEGIC_OBJ_ID    "strategicMapObjectId"
#define OSF_TOC_SQUAD_MANAGER_OBJ_ID    "squadManagerObjectId"

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
// ODA timers (mission seconds)
// Alpha: short values for testing.
// Production: OSF_REPLACEMENT_DURATION = 21600, OSF_INCAP_DURATION = 30 * 60
// ------------------------------------------------------------
#define OSF_REPLACEMENT_DURATION  120  // 2 min testing | production: 21600
#define OSF_INCAP_DURATION        60   // 1 min testing | production: 1800
#define OSF_REVIVE_DURATION_MEDIC 10   // medic with medkit (testing) | production: 30
#define OSF_REVIVE_DURATION_PLAYER 20  // player with medkit (testing) | production: 120

// Unit variable key — set directly on the object at spawn/incap time
#define OSF_ODA_INCAPACITATED     "OSF_incapacitated"
#define OSF_REVIVE_ACTION_ID      "OSF_reviveActionId"
#define OSF_REVIVE_IN_PROGRESS    "OSF_reviveInProgress"

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
