// ============================================================
// OSF_fnc_tocSquadUI
// Opens the squad management dialog and populates it with the
// full ODA roster from OSF_odaRoster.
// 
// params: none
// Returns: nothing
// Usage: [] call OSF_fnc_tocSquadUI;
// ============================================================
#include "..\..\scripts\constants.hpp"

createDialog "OSF_SquadUI";

// --- Header row ---
lnbAddRow [9100, ["RANK", "ROLE", "MOS", "STATUS", "IN SQUAD", "LOADOUT"]];
for "_i" from 0 to 5 do {
	lnbSetColor [9100, [0, _i], [0.95, 0.82, 0.35, 1.0]];
};

// --- Data rows ---
private _roster = [OSF_KEY_ODA_ROSTER, createHashMap] call OSF_fnc_getMissionVar;

{
	private _slot = _y;
	lnbAddRow [9100, [
		_slot get OSF_ODA_RANK,
		_slot get OSF_ODA_ROLE,
		_slot get OSF_ODA_MOS,
		_slot get OSF_ODA_STATUS,
		if (_slot get OSF_ODA_IN_SQUAD) then {
			"YES"
		} else {
			"NO"
		},
		_slot get OSF_ODA_LOADOUT
	]];
} forEach _roster;

["tocSquadUI", format ["%1 slot(s) displayed.", count (keys _roster)]] call OSF_fnc_log;