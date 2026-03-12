// ============================================================
// OSF_fnc_hasVar
// Checks whether a key exists (is not nil) on a given namespace.
//
// Params: [namespace (namespace), key (string)]
// Returns: bool — true if set and not nil
// Usage:  _exists = [missionNamespace, "OSF_sectorState"] call OSF_fnc_hasVar;
//         _exists = [profileNamespace, "OSF_saveExists"]  call OSF_fnc_hasVar;
//         _exists = [uiNamespace,      "OSF_tocDisplay"]  call OSF_fnc_hasVar;
// ============================================================

params ["_ns", "_key"];

private _sentinel = "__OSF_MISSING__";
!(_ns getVariable [_key, _sentinel] isEqualTo _sentinel)
