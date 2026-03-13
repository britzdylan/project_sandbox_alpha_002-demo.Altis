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

// ------------------------------------------------------------
// Profile namespace variable names
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
