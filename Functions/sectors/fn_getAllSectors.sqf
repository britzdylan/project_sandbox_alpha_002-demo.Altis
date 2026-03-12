// ============================================================
// OSF_fnc_getAllSectors
// Returns all registered sector IDs.
//
// Params: none
// Returns: array of sector ID strings
// Usage:  _ids = [] call OSF_fnc_getAllSectors;
// ============================================================

params [];

private _registry = ["OSF_sectorState", createHashMap] call OSF_fnc_getMissionVar;
keys _registry
