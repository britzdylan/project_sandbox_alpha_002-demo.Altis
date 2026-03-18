// ============================================================
// OSF_fnc_tocApplySupplyLoadout
// Applies the TOC supply box loadout to OSF_toc_supply_001.
// Called once from fn_tocInit after TOC state is populated.
//
// params: none
// Returns: nothing
// Usage: [] call OSF_fnc_tocApplySupplyLoadout;
// ============================================================
#include "..\..\scripts\constants.hpp"

private _supplyBox = missionNamespace getVariable ["OSF_toc_supply_001", objNull];

if (isNull _supplyBox) exitWith {
	["tocApplySupplyLoadout", "WARNING: OSF_toc_supply_001 not found — supply loadout not applied."] call OSF_fnc_log;
};

[_supplyBox] call compile preProcessFileLineNumbers "scripts\loadouts\toc_supply.sqf";

["tocApplySupplyLoadout", "Supply loadout applied to OSF_toc_supply_001."] call OSF_fnc_log;
