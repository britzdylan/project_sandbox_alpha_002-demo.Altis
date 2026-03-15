// ============================================================
// scripts/data/loadoutData.sqf
// Maps MOS codes to their available loadout definitions.
// Each entry: [loadoutId, displayName]
//   loadoutId    — matches the filename in scripts/loadouts/
//   displayName  — shown in the Squad UI combo box
// 
// Add a new MOS block here when its loadout scripts are authored.
// Returns: HashMap<MOS (STRING), Array<[id, displayName]>>
// ============================================================

createHashMapFromArray [
	["18X", [
		["oda_nato_rifleman", "NATO - Rifleman"],
		["oda_nato_marksmen", "NATO - Marksman"],
		["oda_nato_auto", "NATO - Auto"],
		["oda_guer_rifleman", "GUER - Rifleman"],
		["oda_guer_marksmen", "GUER - Marksman"],
		["oda_guer_auto", "GUER - Auto"],
		["oda_stealth_rifleman", "STEALTH - Rifleman"],
		["oda_stealth_marksmen", "STEALTH - Marksman"],
		["oda_stealth_auto", "STEALTH - Auto"]
	]],
	["18B", [
		["oda_nato_grenadier", "NATO - Grenadier"],
		["oda_nato_at", "NATO - AT"],
		["oda_guer_grenadier", "GUER - Grenadier"],
		["oda_guer_at", "GUER - AT"],
		["oda_stealth_grenadier", "STEALTH - Grenadier"]
	]],
	["18C", [
		["oda_nato_demo", "NATO - Demo"],
		["oda_nato_eng", "NATO - Engineer"],
		["oda_guer_demo", "GUER - Demo"]
	]],
	["18D", [
		["oda_nato_med", "NATO - Paramedic"],
		["oda_guer_med", "GUER - Paramedic"],
		["oda_stealth_med", "NATO - Paramedic"]
	]],
	["18E", [
		["oda_nato_coms", "NATO - Communications"],
		["oda_stealth_coms", "NATO - Communications"]
	]],
	["18F", [
		["oda_nato_intel", "NATO - Intelligence"],
		["oda_stealth_intel", "NATO - Intelligence"]
	]]
]