// ============================================================
// OSF_fnc_tocSupplyWatcher
// Scheduled loop: restocks OSF_toc_supply_001 every 48 in-game hours.
// Spawned once from fn_tocInit.
//
// params: none
// Returns: nothing
// Usage: [] spawn OSF_fnc_tocSupplyWatcher;
// ============================================================
#include "..\..\scripts\constants.hpp"

// sleep uses real-time seconds; divide by OSF_TIME_MULTIPLIER to convert in-game hours to real seconds
private _intervalSeconds = (48 * 3600) / OSF_TIME_MULTIPLIER;

while {true} do {
	sleep _intervalSeconds;

	[] call OSF_fnc_tocApplySupplyLoadout;
	["tocSupplyWatcher", "48-hour resupply cycle complete — supply box restocked."] call OSF_fnc_log;
};
