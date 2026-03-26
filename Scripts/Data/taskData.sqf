// ============================================================
// scripts/data/taskData.sqf
// Static task definitions — single source of truth for all
// mission tasks. Each entry defines the BIS_fnc_taskCreate
// parameters that don't change at runtime.
//
// Called via: call compile preprocessFileLineNumbers "scripts\data\taskData.sqf"
// Returns: hashmap of taskId → definition hashmap
//
// Definition fields:
//   "description" — full task description text
//   "title"       — short title shown in task list
//   "tag"         — marker tag (3rd element of BIS description array)
//   "type"        — CfgTaskTypes icon type (e.g. "navigate", "attack", "destroy")
//   "priority"    — task priority for auto-selection (-1 = low)
//
// Runtime-only fields NOT stored here:
//   destination (position/object) — set when creating
//   state — tracked in OSF_taskStates hashmap
// ============================================================

private _tasks = createHashMap;

// ----------------------------------------------------------
// TUTORIAL
// ----------------------------------------------------------
_tasks set ["task_establish_toc", createHashMapFromArray [
    ["description", "Establish your Tactical Operations Center at the marked position. This will be your base of operations."],
    ["title", "Establish TOC"],
    ["tag", "TOC"],
    ["type", "navigate"],
    ["priority", -1]
]];

// ----------------------------------------------------------
// SECTOR OBJECTIVES (uncomment as sectors are built)
// ----------------------------------------------------------
// _tasks set ["task_liberate_sector_tutorial", createHashMapFromArray [
//     ["description", "Clear all CSAT forces from the FIA Stronghold sector and hold the command post."],
//     ["title", "Liberate FIA Stronghold"],
//     ["tag", ""],
//     ["type", "attack"],
//     ["priority", 1]
// ]];

// ----------------------------------------------------------
// SIDE OBJECTIVES
// ----------------------------------------------------------
// _tasks set ["task_so_destroy_aa", createHashMapFromArray [
//     ["description", "Locate and destroy the enemy AA emplacement to enable air support operations."],
//     ["title", "Destroy AA Emplacement"],
//     ["tag", ""],
//     ["type", "destroy"],
//     ["priority", 0]
// ]];
//
// _tasks set ["task_so_gather_intel", createHashMapFromArray [
//     ["description", "Retrieve classified documents from the CSAT command post."],
//     ["title", "Gather Intel Documents"],
//     ["tag", ""],
//     ["type", "documents"],
//     ["priority", 0]
// ]];

_tasks
