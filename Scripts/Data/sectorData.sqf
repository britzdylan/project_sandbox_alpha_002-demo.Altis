// ============================================================
// scripts/core/sectorData.sqf
// Static sector definitions — no runtime state, no executable logic.
// Called via: call compile preProcessFileLineNumbers "scripts\core\sectorData.sqf"
// Returns: array of sector definition arrays
// 
// Field order (positional):
//   [0] id               (string)   — unique sector identifier
//   [1] displayName      (string)   — human-readable name
//   [2] operationId      (string)    — ID of the sectors operation
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
		        "sector_tutorial", // [0] id
		        "FIA Stronghold", // [1] displayName
		        "sector_tutorial_operation", // [2] operation ID
		        "marker_sector_tutorial", // [3] boundaryMarker — Eden area marker name
		        "contested", // [4] startStatus
		        [], // [5] adjacency — no adjacent sectors in Alpha
		        4, // [6] commandPoints
		        1, // [7] importance
		        []     // [8] sideObjectives
	]

	    // Future sectors appended here as additional arrays, e.g.:
	   //, 
	    // [
		    //     "sector_02", 
		    //     "Kavala Outskirts", 
		    //     [5200.0, 11400.0, 0], 
		    //     "marker_sector_02", 
		    //     "occupied", 
		    //     ["sector_tutorial"], 
		    //     6, 
		    //     2, 
		    //     ["so_disable_artillery"]
	    // ]
]