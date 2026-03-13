// ============================================================
// scripts/data/odaData.sqf
// Static ODA slot definitions — role structure only.
// No names, no status, no runtime state.
// 
// Called via: call compile preProcessFileLineNumbers "scripts\data\odaData.sqf"
// Returns: array of slot definition arrays
// 
// Field order (positional):
//   [0] slotId       (string) — stable slot identifier; describes the position
//   [1] rank         (string) — "PRIVATE" | "CORPORAL" | "SERGEANT" | "LIEUTENANT" | "CAPTAIN" | "MAJOR"
//   [2] role         (string) — role label displayed in UI
//   [3] mos          (string) — MOS code
//   [4] passiveBonus (string) — "" for none, or bonus identifier
//   [5] unitClass    (string) — engine class passed to createUnit; fixed at spawn, never changes
// 
// NOTE: Each unit can spawn as one of the options noted in the comments.
//       The class chosen at spawn is permanent for that unit's lifetime.
//       Loadout (gear preset) can still be changed at any time via the squad manager.
// 
// Runtime-only fields (seeded by fn_odaInit, never defined here):
//   status, inSquad, identityClass, loadout, unitRef,
//   incapacitatedTimer, replacementTimer
// ============================================================

[
	[
		"slot_scout_0", // Options: Rifleman, Marksman, Auto-rifleman
		"PRIVATE",
		"Scout",
		"18X",
		"",
		"B_recon_F"
	],
	[
		"slot_scout_1", // Options: Rifleman, Marksman, Auto-rifleman
		"PRIVATE",
		"Scout",
		"18X",
		"",
		"B_recon_F"
	],
	[
		"slot_weapons_0", // Options: Grenadier, AT
		"SERGEANT",
		"Weapons Sergeant",
		"18B",
		"",
		"B_recon_GL_F"
	],
	[
		"slot_weapons_1", // Options: Grenadier, AT
		"SERGEANT",
		"Weapons Sergeant",
		"18B",
		"",
		"B_recon_AT_F"
	],
	[
		"slot_engineer_0", // Options: Demo, Mechanic
		"CORPORAL",
		"Engineer",
		"18C",
		"osf_squad_passive_engineer",
		"B_recon_exp_F"
	],
	[
		"slot_engineer_1", // Options: Demo, Mechanic
		"CORPORAL",
		"Engineer",
		"18C",
		"osf_squad_passive_engineer",
		"B_recon_exp_F"
	],
	[
		"slot_intelligence_0", // Options: UAV operator
		"LIEUTENANT",
		"Intel officer",
		"18F",
		"osf_squad_passive_uav",
		"B_recon_F"
	],
	[
		"slot_intelligence_1", // Options: UAV operator
		"LIEUTENANT",
		"Intel officer",
		"18F",
		"osf_squad_passive_uav",
		"B_recon_F"
	],
	[
		"slot_comms_0", // Options: Offshore support
		"LIEUTENANT",
		"Communications officer",
		"18E",
		"osf_squad_comms",
		"B_recon_JTAC_F"
	],
	[
		"slot_comms_1", // Options: Offshore support
		"LIEUTENANT",
		"Communications officer",
		"18E",
		"osf_squad_comms",
		"B_recon_JTAC_F"
	],
	[
		"slot_medic_0", // Options: Paramedic
		"CORPORAL",
		"Paramedic",
		"18D",
		"osf_squad_passive_medical",
		"B_recon_medic_F"
	]
]