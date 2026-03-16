// ============================================================
// OSF_fnc_upgradeInit
// Initialises the upgrade tree state in missionNamespace.
// Creates a HashMap of all 16 node IDs set to false, and sets
// the available command points counter to 0.
//
// Called from fn_boot.sqf on mission start (fresh game only;
// fn_loadState handles restore when a save exists).
//
// params: none
// returns: nothing
// ============================================================

#include "..\..\scripts\constants.hpp"

params [];

["upgradeInit", "starting..."] call OSF_fnc_log;

// Build nodeId → def index (mirrors ODA roster pattern)
private _nodeDefs  = call compile preProcessFileLineNumbers "scripts\data\upgradeData.sqf";
// "upgrade_cap_smallarms" -> ["upgrade_cap_smallarms", "Small Arms", "...", 2, [], "capabilities"]
// "upgrade_cap_technicals" -> ["upgrade_cap_technicals", "Technicals", "...", 6, [...], "capabilities"]
// ...
private _defsIndex = createHashMapFromArray (_nodeDefs apply { [_x select 0, _x] });
[OSF_KEY_UPGRADE_DEFS, _defsIndex] call OSF_fnc_setMissionVar;

// Seed all nodes as unpurchased
// "upgrade_cap_smallarms" -> false
// "upgrade_cap_technicals" -> false
// ...
private _upgradeMap = createHashMapFromArray (keys _defsIndex apply { [_x, false] });
[OSF_KEY_UPGRADE_STATE, _upgradeMap] call OSF_fnc_setMissionVar;
[OSF_KEY_CP_POINTS,     0]           call OSF_fnc_setMissionVar;

["upgradeInit", format ["%1 node(s) initialised. CP: 0.", count _upgradeMap]] call OSF_fnc_log;
