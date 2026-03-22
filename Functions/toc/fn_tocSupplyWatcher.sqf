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

private _intervalGameSeconds = 48 * 3600;
private _nextResupply = time + _intervalGameSeconds;

while {true} do {
	waitUntil { sleep 30; time >= _nextResupply };

	[] call OSF_fnc_tocApplySupplyLoadout;
	["tocSupplyWatcher", "48-hour resupply cycle complete — supply box restocked."] call OSF_fnc_log;

	_nextResupply = _nextResupply + _intervalGameSeconds;
};
