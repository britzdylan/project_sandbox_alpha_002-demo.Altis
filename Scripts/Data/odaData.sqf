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
//   [1] rank         (string) — "PRIVATE" or "CORPORAL" or "SERGEANT" or "LIEUTENANT" or "CAPTAIN" or "MAJOR"
//   [2] role         (string) — role label displayed in UI
//   [3] mos          (string) — MOS code
//   [4] passiveBonus (string) — "" for none, or bonus identifier (see below)
// NOTE!! Each unit can spawn as one of the options mentioned next to their id (cannot be changed after spawn), but in runtime the loadout will be able to change between default, night ops guerilla etc. but the role will stay the same
// Runtime-only fields (seeded by fn_boot, never defined here):
//   status, inSquad, identityClass, loadout, unitRef,
//   incapTimer, replacementTimer
// ============================================================

[
	[
		"slot_scout_0", // Rifleman, marksmen, Auto rifleman
		"PRIVATE",
		"Scout",
		"18X",
		""
	],
	[
		"slot_scout_1", // Rifleman, marksmen, Auto rifleman
		"PRIVATE",
		"Scout",
		"18X",
		""
	],
	[
		"slot_weapons_0", // AT, Grenadier
		"SERGEANT",
		"Weapons Sergeant",
		"18B",
		""
	],
	[
		"slot_weapons_1", // AT, Grenadier
		"SERGEANT",
		"Weapons Sergeant",
		"18B",
		""
	],
	[
		"slot_engineer_0", // Demo, Mechanic
		"CORPORAL",
		"Engineer",
		"18C",
		"osf_squad_passive_engineer" // units spawn with mine detectors or repair kits
	],
	[
		"slot_engineer_1", // Demo, Mechanic
		"CORPORAL",
		"Engineer",
		"18C",
		"osf_squad_passive_engineer" // units spawn with mine detectors or repair kits
	],
	[
		"slot_intelligence_0", // UAV
		"LIEUTENANT",
		"Intel officer",
		"18F",
		"osf_squad_passive_uav" // units spawn with drones and gives access to call in UAV (physical UAV via drongos air ops)
	],
	[
		"slot_intelligence_1", // UAV
		"LIEUTENANT",
		"Intel officer",
		"18F",
		"osf_squad_passive_uav" // units spawn with drones and gives access to call in UAV (physical UAV via drongos air ops)
	],
	[
		"slot_comms_0", // Offshore support
		"LIEUTENANT",
		"Communications officer",
		"18E",
		"osf_squad_comms" // ability to call in air support and naval gunfire
	],
	[
		"slot_comms_1", // Offshore support
		"LIEUTENANT",
		"Communications officer",
		"18E",
		"osf_squad_comms" // ability to call in air support and naval gunfire
	],
	[
		"slot_medic_0", // Paramedic
		"CORPORAL",
		"Paramedic",
		"18D",
		"osf_squad_passive_medical" // carries medkit and can revive incapacitated members in half the time
	]
]