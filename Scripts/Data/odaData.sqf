// ============================================================
// scripts/core/odaData.sqf
// Static ODA roster definitions — no runtime state, no executable logic.
// Called via: call compile preProcessFileLineNumbers "Scripts\Core\odaData.sqf"
// Returns: array of ODA member definition arrays
//
// Field order (positional):
//   [0] id            (string)  — unique member identifier
//   [1] name          (string)  — display name with rank
//   [2] role          (string)  — role description
//   [3] mos           (string)  — MOS code
//   [4] status        (string)  — "active" | "standby" | "incapacitated" | "kia_pending"
//   [5] inSquad       (bool)    — included in active squad loadout
//   [6] passiveBonus  (string)  — "" for none, or bonus identifier (see below)
//
// Passive bonus identifiers:
//   ""                   — no passive bonus
//   "auto_revive"        — 18D: auto-revives incapacitated teammates within 15m
//   "reduced_cd"         — 18E: reduces Drongos support cooldown
//   "ai_accuracy"        — 18B: improves AI teammate accuracy
//
// Runtime-only fields (seeded by fn_initGameState, never defined here):
//   incapTimer, replacementTimer
// ============================================================

[
    // ----------------------------------------------------------
    // Command Element
    // ----------------------------------------------------------
    [
        "oda_01_cole",          // [0] id
        "CPT Marcus Cole",      // [1] name
        "Team Commander",       // [2] role
        "18A",                  // [3] mos
        "active",               // [4] status
        true,                   // [5] inSquad
        ""                      // [6] passiveBonus
    ],
    [
        "oda_02_holt",          // [0] id
        "WO2 Daniel Holt",      // [1] name
        "Asst. Detachment Cmdr",// [2] role
        "180A",                 // [3] mos
        "active",               // [4] status
        true,                   // [5] inSquad
        ""                      // [6] passiveBonus
    ],
    [
        "oda_03_vega",          // [0] id
        "MSG Ramon Vega",       // [1] name
        "Team Sergeant",        // [2] role
        "18Z",                  // [3] mos
        "active",               // [4] status
        true,                   // [5] inSquad
        ""                      // [6] passiveBonus
    ],

    // ----------------------------------------------------------
    // Weapons Sergeants (18B)
    // ----------------------------------------------------------
    [
        "oda_04_moss",          // [0] id
        "SFC Derek Moss",       // [1] name
        "Weapons Sergeant",     // [2] role
        "18B",                  // [3] mos
        "active",               // [4] status
        true,                   // [5] inSquad
        "ai_accuracy"           // [6] passiveBonus
    ],
    [
        "oda_05_reyes",         // [0] id
        "SSG Anton Reyes",      // [1] name
        "Weapons Sergeant",     // [2] role
        "18B",                  // [3] mos
        "active",               // [4] status
        true,                   // [5] inSquad
        "ai_accuracy"           // [6] passiveBonus
    ],

    // ----------------------------------------------------------
    // Engineer Sergeants (18C)
    // ----------------------------------------------------------
    [
        "oda_06_burke",         // [0] id
        "SFC Owen Burke",       // [1] name
        "Engineer Sergeant",    // [2] role
        "18C",                  // [3] mos
        "active",               // [4] status
        true,                   // [5] inSquad
        ""                      // [6] passiveBonus
    ],
    [
        "oda_07_hale",          // [0] id
        "SSG Travis Hale",      // [1] name
        "Engineer Sergeant",    // [2] role
        "18C",                  // [3] mos
        "active",               // [4] status
        true,                   // [5] inSquad
        ""                      // [6] passiveBonus
    ],

    // ----------------------------------------------------------
    // Medical Sergeants (18D)
    // ----------------------------------------------------------
    [
        "oda_08_cross",         // [0] id
        "SFC Nathan Cross",     // [1] name
        "Medical Sergeant",     // [2] role
        "18D",                  // [3] mos
        "active",               // [4] status
        true,                   // [5] inSquad
        "auto_revive"           // [6] passiveBonus
    ],
    [
        "oda_09_vargas",        // [0] id
        "SSG Luis Vargas",      // [1] name
        "Medical Sergeant",     // [2] role
        "18D",                  // [3] mos
        "active",               // [4] status
        true,                   // [5] inSquad
        "auto_revive"           // [6] passiveBonus
    ],

    // ----------------------------------------------------------
    // Communications Sergeants (18E)
    // ----------------------------------------------------------
    [
        "oda_10_shaw",          // [0] id
        "SFC Eric Shaw",        // [1] name
        "Communications Sergeant", // [2] role
        "18E",                  // [3] mos
        "active",               // [4] status
        true,                   // [5] inSquad
        "reduced_cd"            // [6] passiveBonus
    ],
    [
        "oda_11_park",          // [0] id
        "SSG David Park",       // [1] name
        "Communications Sergeant", // [2] role
        "18E",                  // [3] mos
        "active",               // [4] status
        true,                   // [5] inSquad
        "reduced_cd"            // [6] passiveBonus
    ],

    // ----------------------------------------------------------
    // Intelligence Sergeant (18F)
    // ----------------------------------------------------------
    [
        "oda_12_tatum",         // [0] id
        "SFC James Tatum",      // [1] name
        "Intelligence Sergeant",// [2] role
        "18F",                  // [3] mos
        "active",               // [4] status
        true,                   // [5] inSquad
        ""                      // [6] passiveBonus
    ]
]
