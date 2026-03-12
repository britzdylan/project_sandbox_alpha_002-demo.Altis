// ============================================================
// scripts/core/sectorData.sqf
// Static sector definitions — no runtime state, no executable logic.
// Called via: call compile preProcessFileLineNumbers "scripts\core\sectorData.sqf"
// Returns: array of sector definition arrays
// 
// Field order (positional):
//   [0] id               (string)   — unique sector identifier
//   [1] displayName      (string)   — human-readable name
//   [2] poiPos           (array)    — [x, y, z] position of capture POI
//   [3] boundaryMarker   (string)   — Eden area marker name for sector boundary
//   [4] startStatus      (string)   — "occupied" | "contested" | "liberated"
//   [5] adjacency        (array)    — array of adjacent sector IDs (strings)
//   [6] commandPoints    (number)   — total CP capacity for militia allocation
//   [7] importance       (number)   — 1=low, 2=medium, 3=high (counterattack scaling)
//   [8] sideObjectives   (array)    — side objective IDs associated with this sector
// 
// Runtime-only fields (seeded empty by fn_initGameState, never defined here):
//   militia, hbqModules, completedSideObjectives, counterattackActive
// ============================================================

[
	    // ----------------------------------------------------------
	    // SECTOR: Tutorial NW — Therisa Command Post
	    // Alpha phase tutorial sector. Only available sector at start.
	    // ----------------------------------------------------------
	[
		        "sector_tutorial_nw", // [0] id
		        "FIA Stronghold", // [1] displayName
		        [9142.61, 21540, 0], // [2] poiPos — adjust to Eden POI placement
		        "marker_sector_tutorial_nw", // [3] boundaryMarker — Eden area marker name
		        "contested", // [4] startStatus
		        [], // [5] adjacency — no adjacent sectors in Alpha
		        4, // [6] commandPoints
		        1, // [7] importance
		        ["so_aa_emplacement", "so_intel_documents"]     // [8] sideObjectives
	]

	    // Future sectors appended here as additional arrays, e.g.:
	    //, 
	    // [
		    //     "sector_02", 
		    //     "Kavala Outskirts", 
		    //     [5200.0, 11400.0, 0], 
		    //     "marker_sector_02", 
		    //     "occupied", 
		    //     ["sector_tutorial_nw"], 
		    //     6, 
		    //     2, 
		    //     ["so_disable_artillery"]
	    // ]
]