# Squad Action Menu — Player Guide

## Overview
The squad action menu gives you direct, real-time command over your ODA fireteam without
breaking immersion. Open it via your configured key and navigate the submenus below.

---

## SQUAD > Movement

| Action | What it does |
|--------|-------------|
| **Move** | Orders squad to move to your screen center (cursor world position). |
| **Move Fast** | Same as Move but at full speed. |
| **Follow Me** | Calls `fn_regroup` — see custom functions below. |
| **Halt** | All units stop immediately. |
| **Go Prone** | Forces all units to lie down. |
| **Stay Low** | Forces all units to crouch. |
| **Stand Up** | Forces all units to stand. |

---

## SQUAD > Tactical

These are the core custom movement orders. See the **Custom Functions** section for full detail.

| Action | What it does |
|--------|-------------|
| **Advance** | Calls `fn_advance` — bound forward in pairs. |
| **Flank Left** | *(Not yet implemented)* |
| **Flank Right** | *(Not yet implemented)* |
| **Stay Back** | *(Not yet implemented)* |
| **Defend** | Calls `fn_findCover` — disperses squad to nearby cover. |
| **Retreat** | Calls `fn_retreat` — withdraws squad away from contact. |

---

## SQUAD > Target

| Action | What it does |
|--------|-------------|
| **Suppress** | Calls `fn_suppressArea` — squad suppresses your cursor target for 20s. |
| **Watch** | All units watch your screen center position. |
| **Target** | All units target your cursor target object. |

---

## SQUAD > ROE

Controls rules of engagement for the whole group.

| Action | Combat Mode | Meaning |
|--------|-------------|---------|
| **Hold Fire** | BLUE | Units will not fire under any circumstance. |
| **Return Fire** | WHITE | Units fire only if fired upon. |
| **Fire on my Lead** | — | Calls `fn_fireOnLead` — see custom functions below. |
| **Engage at Will** | RED | Units engage any detected enemy freely. |

---

## SQUAD > Behaviour

Sets the AI alertness level for all units including the player.

| Action | Behaviour | Effect |
|--------|-----------|--------|
| **Combat** | COMBAT | Units actively scan, take cover, and react aggressively. |
| **Stealth** | STEALTH | Units move quietly and avoid detection. |
| **Aware** | AWARE | Default patrol state — alert but not actively hunting. |

---

## SQUAD > Formation

Sets the group formation. All standard Arma 3 formations:
**Wedge, Column, Diamond, Line, File, Staggered (Stag Column), Echelon Left, Echelon Right, Vee.**

---

## SQUAD > Equipment

| Action | Effect |
|--------|--------|
| **Lasers On / Off** | Toggles IR lasers for all group members. |
| **Lights On / Off** | Toggles weapon flashlights for all group members. |

---

## Custom Functions — Detail

### `fn_advance` — Advance
**Use when:** Moving across open terrain with no confirmed contact.
**Do not use:** In towns or confined spaces where pairs are exposed between bounds.

1. All units drop prone and watch 360° (evenly distributed directions).
2. After a short delay, the squad moves forward to a position **75m ahead of the player**.
3. Units move in **pairs**, one pair at a time. The next pair does not move until the
   current pair has arrived (or a timeout expires).
4. On arrival, each pair drops prone and holds in **AWARE / hold fire**.

---

### `fn_retreat` — Retreat
**Use when:** Unexpected contact and you need to break contact fast.
**Do not use:** When already heavily engaged — fight your way out instead.

1. Calculates a bearing **180° away from the nearest enemy** (or current facing if no
   enemy is detected).
2. All units drop prone and watch 360°.
3. Units move in pairs to positions **150m to the rear**, each pair deploying a **smoke
   grenade** before moving.
4. 15-second timeout per pair prevents the loop from stalling on stuck units.
5. On arrival, units hold in **AWARE / safe**.

---

### `fn_regroup` — Follow Me
**Use when:** After any movement order to bring the squad back into formation.

1. All units are ordered to **follow the player** (formation restored).
2. Activates **stance mirroring**: while a unit is following the player, it will
   automatically copy any stance change you make (stand → stand, crouch → crouch,
   prone → prone). Mirroring stops automatically for any unit given an independent order.

---

### `fn_findCover` — Defend
**Use when:** Taking fire and needing the squad off the road and into cover immediately.

1. Each unit is assigned a **unique safe position** within the defend radius around the player.
2. If an **empty static weapon emplacement** is nearby, the unit crews it instead of
   finding ground cover.
3. Units move to their position at full speed, then switch to **COMBAT / YELLOW** and
   watch forward once in position.
4. 60-second movement timeout per unit prevents stalling.

---

### `fn_suppressArea` — Suppress
**Use when:** Pinning an enemy position while you or another element maneuvers.

1. All units target your **cursor target** and suppress it for **20 seconds**.
2. Each unit is spawned independently so suppression runs in parallel — the whole squad
   lays down fire simultaneously.
3. Units are forced into **COMBAT / RED** regardless of current behaviour.

---

### `fn_fireOnLead` — Fire on my Lead
**Use when:** Setting up a coordinated ambush or volley fire.

1. All units are locked to **hold fire (BLUE)** immediately.
2. The moment **you fire your weapon**, all units simultaneously switch to **engage at
   will (RED)**.
3. The trigger is **one-shot** — it removes itself after your first shot.
