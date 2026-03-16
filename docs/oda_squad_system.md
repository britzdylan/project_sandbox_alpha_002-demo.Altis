# ODA Squad Management System

**Operation Sovereign Fury — Alpha Phase**

---

## Overview

The ODA Squad System manages a 12-member Special Forces Operational Detachment Alpha. It handles the full unit lifecycle: spawning, incapacitation, revival, permanent death, and field replacement. Units are deployed and dismissed via a squad manager UI at the TOC.

---

## File Map

```
Functions/
  oda/
    fn_odaInit.sqf              — Initialize roster from static data
    fn_odaSpawn.sqf             — Spawn a single unit into the world
    fn_odaIncap.sqf             — Trigger incapacitation on fatal damage
    fn_odaIncapWatcher.sqf      — Loop: monitor incap timers + medic auto-revive
    fn_odaRevive.sqf            — Execute revive sequence (player or medic)
    fn_odaHandleUnitDeath.sqf   — Handle KIA state transition
    fn_odaReplacementWatcher.sqf — Loop: monitor replacement timer
    fn_odaDismiss.sqf           — Remove unit from field (standby)
    fn_odaApplyLoadout.sqf      — Apply a loadout script to a slot
  toc/
    fn_tocSquadUI.sqf           — Squad manager dialog logic

scripts/
  data/
    odaData.sqf                 — Static slot definitions (11 slots)
    loadoutData.sqf             — MOS → available loadouts map
  loadouts/
    *.sqf                       — Individual loadout scripts (28 total)
  constants.hpp                 — Global constants and timer values
```

---

## Slot Definitions (`odaData.sqf`)

11 slots are defined statically. Each definition is a positional array:

| Index | Field         | Description                               |
|-------|---------------|-------------------------------------------|
| 0     | `slotId`      | Unique ID string (e.g. `"slot_scout_0"`)  |
| 1     | `rank`        | `"PRIVATE"`, `"CORPORAL"`, `"SERGEANT"`, `"LIEUTENANT"` |
| 2     | `role`        | Display name (e.g. `"Scout"`)             |
| 3     | `mos`         | MOS code (see table below)                |
| 4     | `passiveBonus`| Passive bonus ID or `""`                  |
| 5     | `unitClass`   | Arma engine class string                  |
| 6     | `loadout`     | Default loadout script name               |

**Slot roster:**

| Slot ID                  | Rank       | Role                | MOS  | Passive Bonus                   |
|--------------------------|------------|---------------------|------|---------------------------------|
| `slot_scout_0`           | SERGEANT   | Scout               | 18X  | —                               |
| `slot_scout_1`           | PRIVATE    | Scout               | 18X  | —                               |
| `slot_weapons_0`         | SERGEANT   | Weapons Sergeant    | 18B  | —                               |
| `slot_weapons_1`         | PRIVATE    | Weapons Sergeant    | 18B  | —                               |
| `slot_engineer_0`        | SERGEANT   | Engineer            | 18C  | `osf_squad_passive_engineer`    |
| `slot_engineer_1`        | PRIVATE    | Engineer            | 18C  | `osf_squad_passive_engineer`    |
| `slot_intelligence_0`    | SERGEANT   | Intelligence Officer| 18F  | `osf_squad_passive_uav`         |
| `slot_intelligence_1`    | PRIVATE    | Intelligence Officer| 18F  | `osf_squad_passive_uav`         |
| `slot_comms_0`           | SERGEANT   | Communications SGT  | 18E  | `osf_squad_comms`               |
| `slot_comms_1`           | PRIVATE    | Communications SGT  | 18E  | `osf_squad_comms`               |
| `slot_medic_0`           | SERGEANT   | Medic               | 18D  | `osf_squad_passive_medical`     |

> **Note:** Passive bonuses are stored in slot data but not yet active. Scheduled for Phase B–C.

---

## Roster State

The roster lives in `missionNamespace` under `OSF_KEY_ODA_ROSTER` as a `HashMap<slotId, HashMap<field, value>>`.

**Fields per slot:**

| Field                | Type    | Description                                             |
|----------------------|---------|---------------------------------------------------------|
| `slotId`             | String  | Matches the key in the outer hashmap                    |
| `rank`               | String  | From static data                                        |
| `role`               | String  | Display name                                            |
| `mos`                | String  | MOS code                                                |
| `passiveBonus`       | String  | Passive bonus ID or `""`                                |
| `unitClass`          | String  | Engine unit class                                       |
| `loadout`            | String  | Current loadout script name                             |
| `status`             | String  | Current lifecycle status (see Status section)           |
| `inSquad`            | Bool    | `true` if unit is deployed to field                     |
| `identityClass`      | String  | Assigned identity (`OSF_ODA_01`–`OSF_ODA_24`)           |
| `unitRef`            | Object  | Reference to spawned unit; `objNull` if not deployed    |
| `incapacitatedTimer` | Number  | Mission time (seconds) when KIA fires; `-1` if inactive |
| `replacementTimer`   | Number  | Mission time when slot returns to standby; `-1` if n/a  |

**Unit-level variables** (set directly on the unit object):

| Variable              | Type   | Description                                      |
|-----------------------|--------|--------------------------------------------------|
| `OSF_slotId`          | String | Back-reference to this unit's slot               |
| `OSF_incapacitated`   | Bool   | True while unit is in incapacitated state        |
| `OSF_reviveActionId`  | Number | Hold-action ID for player revive (for removal)   |
| `OSF_reviveInProgress`| Bool   | True while a revive is actively executing        |

---

## Unit Status

| Status                  | Constant                      | Meaning                                          |
|-------------------------|-------------------------------|--------------------------------------------------|
| `"active"`              | `OSF_ODA_STATUS_ACTIVE`       | Deployed and combat-ready                        |
| `"inactive"`            | `OSF_ODA_STATUS_INACTIVE`     | Standing by; can be deployed                     |
| `"incapacitated"`       | `OSF_ODA_STATUS_INCAP`        | Downed; timer running toward KIA                 |
| `"r&r"`                 | `OSF_ODA_STATUS_RR`           | Rest and recovery (reserved for future use)      |
| `"kia"`                 | `OSF_ODA_STATUS_KIA`          | Killed; replacement pipeline running             |
| `"redeployment_in_progress"` | `OSF_ODA_STATUS_REDEPLOYMENT` | Reserved; not yet used                      |

---

## Unit Lifecycle

```
[INACTIVE] ──deploy──► [ACTIVE] ──fatal damage──► [INCAPACITATED]
    ▲                     ▲                              │
    │                     │                     timer expires / KIA
    │                  revive                            │
    │               (player or medic)                    ▼
    │                     └──────────────────────────[KIA]
    │                                                    │
    └────────────────── replacement timer ───────────────┘
```

**Dismiss** (at TOC) returns an `"active"` unit directly to `"inactive"`. No death/replacement involved.

---

## Function Reference

### `fn_odaInit`
Loads slot definitions from `odaData.sqf`, builds the roster hashmap with default runtime values, stores it in `missionNamespace`, then immediately spawns all 11 units via `fn_odaSpawn`.

```sqf
[] call OSF_fnc_odaInit;
```

---

### `fn_odaSpawn`
Spawns a single unit into the world. Assigns a random unused identity from the 24-identity pool. Creates the unit in the player's group, applies rank/skill, identity, and default loadout. Wires the `handleDamage` and `killed` event handlers.

```sqf
// Parameters: [slotId, spawnPos (optional, defaults to player pos)]
["slot_scout_0"] call OSF_fnc_odaSpawn;
["slot_medic_0", [1234, 5678, 0]] call OSF_fnc_odaSpawn;
// Returns: created unit object, or objNull on failure
```

**Event handlers wired on spawn:**
- `handleDamage` — intercepts fatal damage (≥1.0), triggers `fn_odaIncap`, returns `0.95` (sub-lethal so death isn't instant)
- `killed` — fires when unit actually dies, calls `fn_odaHandleUnitDeath`

---

### `fn_odaIncap`
Called from the `handleDamage` EH. Marks the slot as `"incapacitated"`, sets the KIA deadline, freezes damage, plays the unconscious animation, adds a player revive hold-action, and spawns the incap watcher loop.

```sqf
// Parameters: [unit, slotId]
// (Called internally from handleDamage EH — not called directly)
```

**Player revive hold-action conditions:**
- Player must be within 5m
- Player must have `Medkit` in inventory
- Hold duration: `OSF_REVIVE_DURATION_PLAYER`

---

### `fn_odaIncapWatcher`
A scheduled loop spawned by `fn_odaIncap`. Runs every 5 seconds.

**Each tick checks, in order:**
1. Slot no longer exists or status is no longer `"incapacitated"` → clean exit
2. Unit object is null → exit
3. Medic auto-revive eligibility (see below)
4. Timer expired → re-enable damage, call `setDamage 1.1`, loop exits (triggers `killed` EH)

**Medic auto-revive conditions:**
- A unit in the player's group with MOS `18D` must exist
- Medic must be alive (not incapacitated)
- Medic must have `Medikit` in inventory
- Medic must be within 25m of the downed unit
- No revive must already be in progress (`OSF_reviveInProgress` on medic or downed unit)

When conditions are met, `fn_odaRevive` is spawned automatically.

---

### `fn_odaRevive`
Executes the full revive sequence. Handles both player-initiated and medic-initiated revival.

```sqf
// Parameters: [unit, isMedic, skipSleep (optional, default false)]
[_unit, false] spawn OSF_fnc_odaRevive;  // player revive
[_unit, true]  spawn OSF_fnc_odaRevive;  // medic revive
```

**Flow:**
1. Guard check: exit if slot status has changed (race condition safety)
2. If medic: find medic unit, move medic to downed unit (wait until within 2m), play smoke animation
3. Sleep for revive duration (unless `skipSleep = true` — hold-action already waited)
4. Guard check again (timer may have expired during sleep)
5. Restore unit: `setUnconscious false`, `allowDamage true`, `setDamage 0.5`
6. Medic performs `HealSoldier` action
7. Update slot: status `"active"`, clear `incapacitatedTimer`, remove hold-action, clear revive flags

---

### `fn_odaHandleUnitDeath`
Fired by the `killed` EH. Transitions the slot to `"kia"` and starts the replacement pipeline.

```sqf
// Parameters: [unit, killer, instigator]
// (Called internally from killed EH — not called directly)
```

**Guard:** Exits early if `OSF_incapacitated` is still `true` on the unit (prevents double-trigger while the incap watcher is still cleaning up).

Sets `replacementTimer = time + OSF_REPLACEMENT_DURATION`, clears `unitRef` and `inSquad`, spawns `fn_odaReplacementWatcher`.

---

### `fn_odaReplacementWatcher`
A scheduled loop spawned by `fn_odaHandleUnitDeath`. Waits until `time >= replacementTimer`, then sets slot status back to `"inactive"` (ready to deploy).

```sqf
// Parameters: [slotId, targetTime]
// (Spawned internally — not called directly)
```

---

### `fn_odaDismiss`
Removes a deployed unit from the field and returns the slot to standby. Does not trigger death or replacement.

```sqf
// Parameters: [slotId]
["slot_scout_0"] call OSF_fnc_odaDismiss;
```

Leaves the unit's group, deletes the unit object, resets slot fields: `status = "inactive"`, `inSquad = false`, `unitRef = objNull`.

---

### `fn_odaApplyLoadout`
Applies a loadout script to a slot. Updates the slot's `loadout` field and, if the unit is currently spawned and local, immediately re-equips the unit.

```sqf
// Parameters: [slotId, loadoutId]
["slot_scout_0", "oda_nato_rifleman"] call OSF_fnc_odaApplyLoadout;
```

Loadout scripts live in `scripts/loadouts/{loadoutId}.sqf`. Each script receives the unit as its `this` context, strips all existing gear, and applies new weapons, attachments, ammo, and containers.

---

## Squad Manager UI

Accessed via hold-action on the **Squad Manager** object at the TOC.

**Dialog ID:** `9001` (`OSF_SquadUI`)

| Control ID | Type      | Purpose                              |
|------------|-----------|--------------------------------------|
| 9100       | ListNBox  | Roster list (6 columns)              |
| 9201       | Button    | Deploy selected slot                 |
| 9202       | Button    | Dismiss selected slot                |
| 9203       | ComboBox  | Loadout selector for selected slot   |
| 9300       | Text      | Status count stats bar               |
| 9200       | Button    | Close dialog                         |

**Roster columns:** RANK | ROLE | MOS | STATUS | IN SQUAD | LOADOUT

**Status color coding:**

| Status  | Color             |
|---------|-------------------|
| ACTIVE  | Green             |
| STANDBY | Gray              |
| INCAP   | Orange            |
| R&R     | Yellow            |
| KIA     | Red               |
| INBOUND | Blue              |

**Row selection behavior:**
- Deploy button enabled only when status = `"inactive"`
- Dismiss button enabled only when status = `"active"`
- Loadout combo populated with MOS-appropriate options when status = `"active"` or `"inactive"`

The `slotId` is stored as hidden data on column 0 of each row and retrieved by action handlers.

---

## Identity System

24 identities are pre-defined in `description.ext` as `CfgIdentities` classes `OSF_ODA_01`–`OSF_ODA_24`. Each has a unique surname, face model, voice, and pitch.

On spawn, a random unused identity is selected from the pool and applied via `setIdentity`. The assigned class is stored in `identityClass` on the slot. Identity persists across incap/revive cycles. If a unit is dismissed and re-spawned, their identity may change.

---

## Loadout System

**Data source:** `scripts/data/loadoutData.sqf`
Defines a `HashMap<MOS, Array<[loadoutId, displayName]>>`.

| MOS  | Available loadouts             |
|------|-------------------------------|
| 18X  | 9 (NATO/GUER/STEALTH × Rifleman/Marksman/Auto) |
| 18B  | 5 (NATO/GUER/STEALTH × Grenadier/AT)           |
| 18C  | 3 (NATO/GUER × Demo/Engineer)                   |
| 18D  | 3 (NATO/GUER/STEALTH × Paramedic)               |
| 18E  | 2 (NATO/STEALTH × Communications)               |
| 18F  | 2 (NATO/STEALTH × Intelligence)                 |

Loadout scripts (`scripts/loadouts/*.sqf`) strip all gear then apply a full kit. They receive the unit object as their execution context.

---

## Timer Constants

Defined in `scripts/constants.hpp`. Testing values are active for Alpha; production values are commented alongside.

| Constant                    | Testing | Production    |
|-----------------------------|---------|---------------|
| `OSF_INCAP_DURATION`        | 60s     | 1800s (30 min)|
| `OSF_REVIVE_DURATION_PLAYER`| 20s     | 120s (2 min)  |
| `OSF_REVIVE_DURATION_MEDIC` | 10s     | 30s           |
| `OSF_REPLACEMENT_DURATION`  | 120s    | 21600s (6 hr) |

---

## Passive Bonuses (Planned — Not Yet Active)

| Bonus ID                      | MOS  | Planned Effect                              |
|-------------------------------|------|---------------------------------------------|
| `osf_squad_passive_engineer`  | 18C  | TBD (Phase B)                               |
| `osf_squad_passive_uav`       | 18F  | TBD — likely UAV terminal access            |
| `osf_squad_passive_medical`   | 18D  | Medic auto-revive (already active via MOS)  |
| `osf_squad_comms`             | 18E  | TBD — likely reduced Drongos cooldown       |

Bonus IDs are stored in `passiveBonus` on each slot for future activation logic.

---

## Save System

ODA state **is not yet persisted** to `profileNamespace`. The save system (`fn_saveState` / `fn_loadState`) currently handles sector state only. ODA persistence is planned for Phase B.

**When implemented, persistence will need to cover:**
- `status`, `loadout`, `identityClass` per slot
- `incapacitatedTimer`, `replacementTimer` (surviving a reload mid-timer)
- `unitRef` cannot be serialized — units must be re-spawned on load

---

## Initialization Chain

```
init.sqf
  └─► OSF_fnc_boot
        ├─► OSF_fnc_odaInit          ← builds roster + spawns all 11 units
        └─► OSF_fnc_tocInit          ← registers TOC objects + wires hold-actions
              └─► hold-action: "Squad Manager" → OSF_fnc_tocSquadUI
```
