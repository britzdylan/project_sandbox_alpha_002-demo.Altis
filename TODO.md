# POC Checklist — Sector 0: Abdera Airfield

Target: Every system domain represented at minimum viable level.
Scope: One sector (Abdera Airfield), one operation, the tutorial flow, and immediate surroundings.
Goal: Prove the core loop works end-to-end before building content.

---

## Systems Architecture

- [x] Define file/folder structure (scripts per domain)
- [x] Init chain: `init.sqf` → domain inits in defined order
- [x] Global variable naming convention decided and documented
- [x] Basic event system (CBA events or custom global variable flags)
- [x] Debug overlay togglable with a keybind (shows: AI count, FPS, current game state, CP balance)
- [x] RPT logging per domain with toggleable verbosity

---

## Player State & Persistence

- [x] Save data schema defined (all fields, types, defaults, version number)
- [x] Save function: serialize all domain states to `profileNamespace`
- [x] Load function: deserialize and restore all domain states
- [x] Save only available at TOC (action on TOC object)
- [x] Autosave triggers: on sector liberation, on operation start, on HUMINT complete
- [x] New game initializer (fresh state, first-time flag)
- [x] Save data validation on load (check for missing/corrupt fields, apply defaults)
- [x] Verify: save at TOC → close Arma → relaunch → load → world state intact

---

## Core Gameplay Loop

- [ ] Tutorial intro sequence: player + squad start at initial position, guided to Abdera Airfield
- [ ] Tutorial prompts: basic movement, combat, squad commands (text hints, not blocking)
- [ ] First objective leads player to discover/establish TOC
- [ ] TOC established → core loop begins
- [ ] Player death in open play → respawn at TOC, squad teleports with player
- [ ] Verify: full loop completes — TOC → sector → operation → liberate → earn CP → spend CP

---

## Environment

- [x] Altis loaded, no terrain restrictions needed for POC (but mentally scope testing to NE corner)
- [x] Dynamic weather running (`setWeather` random or scripted cycle)
- [x] Time multiplier set to 6x (`setTimeMultiplier 6`)
- [ ] Basic ambient life near Abdera: 2-3 abandoned vehicle wrecks (static compositions)
- [ ] 1-2 destroyed/vandalized building clusters near sector
- [ ] Verify: day/night cycle feels right at 6x, weather transitions aren't jarring

---

## Locations

- [x] **TOC** — placed near Abdera, functional:
  - [xm] Object(s) the player interacts with (table, tent, flag — whatever represents the command post)
  - [ ] Save action on TOC object
  - [x] Squad menu access point
  - [x] FIA upgrades access point
  - [x] Strategic map access point
  - [ ] Campaign overview access point
- [ ] **Abdera Airfield** — operation sector:
  - [ ] Sector boundary defined (trigger area or marker radius)
  - [ ] Sector state: CONTESTED → LIBERATED (flips on condition)
  - [ ] Liberation condition: all garrison enemies dead or area control (pick one, test it)
  - [ ] Sector marker on map updates with state (color/icon change)
- [ ] **1x Secondary Objective location** — placed near Abdera:
  - [ ] Location defined, marker placed
  - [ ] Accessible before operation starts
- [ ] **1x HUMINT mission location** — placed in liberated area:
  - [ ] Location defined, marker placed
  - [ ] Only appears after Abdera is liberated
- [ ] **1x FIA Support Op location** — in contested/enemy territory:
  - [ ] Location defined, marker placed
  - [ ] Only appears after Abdera is liberated
- [ ] **1x FIA Location** — old spec ops outpost becomes FIA camp after liberation:
  - [ ] Composition swap on liberation (barren outpost → FIA camp with defenders)
- [ ] **1x Opfor fortification** — DUMP checkpoint near sector:
  - [ ] Spawned, garrisoned
  - [ ] Keeps respawning until sector captured
  - [ ] Stops respawning after liberation
- [ ] Verify: all locations appear/disappear at correct game states

---

## AI & Factions

- [ ] Faction sides configured: NATO (BLUFOR), FIA (BLUFOR/Independent — pick side), AAF (OPFOR), CSAT (OPFOR), PMC (Independent), CIV (Civilian)
- [ ] Faction relationships set (`setFriend` / side friendliness)
- [ ] **Spawn manager** — the critical system:
  - [ ] AI budget cap defined (variable, e.g. `RPG_AI_CAP = 60`)
  - [ ] Current AI count tracked (updated on spawn/death)
  - [ ] Spawn blocked when at cap
  - [ ] Distance-based spawning: garrison spawns when player within X meters
  - [ ] Distance-based despawning: garrison despawns when player beyond Y meters (only if not in combat)
  - [ ] `enableDynamicSimulation true` on every spawned group
  - [ ] Empty group cleanup (delete groups with no units)
  - [ ] Dead body cleanup on timer
- [ ] **Abdera garrison:**
  - [ ] AAF units, hand-placed composition or spawned from config array
  - [ ] Skill set to AAF base value (0.3 or your adjusted value)
  - [ ] Mix of static defenders + 1-2 patrols within sector
- [ ] **DUMP checkpoint garrison:**
  - [ ] Small AAF group (3-5 units)
  - [ ] Respawn logic on timer if destroyed and sector not liberated
- [ ] **Player squad:**
  - [ ] Spawned at game start, follows player
  - [ ] Skill set to player squad value (0.6-0.7 recommended)
  - [ ] Persists through save/load (respawned from saved loadout data)
- [ ] **FIA defenders** (post-liberation):
  - [ ] Small FIA group spawns at FIA camp after liberation
  - [ ] Skill set to FIA value (0.2-0.25 recommended)
  - [ ] Count pulled from FIA unit pool
- [ ] Verify: AI count never exceeds budget cap during gameplay
- [ ] Verify: spawning/despawning isn't visible to player (no pop-in within sight)
- [ ] Verify: frame rate stable with full garrison + player squad + patrol active

---

## Progression (Minimal for POC)

- [ ] CP variable initialized at 0
- [ ] CP earned on: HUMINT completion (+1), FIA Support Op completion (+1)
- [ ] CP display somewhere visible (HUD element or debug overlay)
- [ ] FIA level system: Level 0 at start
- [ ] 1 upgrade purchasable with CP to prove the system works (e.g., FIA gear tier 1 OR unlock one support asset)
- [ ] Upgrade state saved/loaded
- [ ] Verify: earn CP → spend CP → effect visible in world or available support

---

## Economy

- [ ] CP as sole currency — tracked, displayed, saved, loaded
- [ ] 1x loot source: enemies drop weapons/gear on death (vanilla Arma behavior, no custom system needed for POC)
- [ ] FIA unit pool: starts at base value, increases after HUMINT complete
- [ ] Verify: CP balance persists across save/load
- [ ] Verify: FIA pool increase results in more FIA units at FIA camp

---

## Narrative & Quests

### Operation (1x — Abdera Airfield Assault)

- [ ] Operation defined in data format (ID, name, sector, objectives, timer, briefing text)
- [ ] Activated via strategic map at TOC
- [ ] **Briefing screen:** map overview, objective description, approach selection (even if only 1 approach for POC)
- [ ] **Staging area:** player teleported/moved to insertion point
- [ ] **Timed objectives:** at least 2 objectives (e.g., destroy AA emplacement, secure airfield)
- [ ] **Timer running:** visible on HUD, operation fails if timer expires
- [ ] **Friendly AI support:** FIA or NATO AI assist during operation (even if just 1 squad)
- [ ] **Victory condition:** objectives complete + area cleared
- [ ] **Failure condition:** timer expires OR excessive friendly casualties
- [ ] **On victory:** sector state → LIBERATED, CP awarded, side effects trigger
- [ ] **On failure:** global fail counter +1, respawn at TOC, operation replayable
- [ ] Operation state saved (completed/failed/available)

### Secondary Objective (1x)

- [ ] Pre-placed near Abdera (e.g., clear roadblock OR destroy mine on road)
- [ ] Available before operation starts when sector becomes contested
- [ ] Completion reduces operation difficulty (fewer garrison units OR extended timer)
- [ ] If not completed before operation ends: objective cancelled, removed from map
- [ ] State tracked and saved

### HUMINT Mission (1x)

- [ ] Available only after Abdera liberated
- [ ] Non-combat (e.g., transport civilian to Oreokastro)
- [ ] On completion: +1 CP, FIA pool increased
- [ ] Becomes unavailable if sector lost to counter-attack
- [ ] State tracked and saved

### FIA Support Op (1x)

- [ ] Available after liberation, in contested/enemy territory
- [ ] Combat mission (e.g., destroy cache stash)
- [ ] On completion: +1 CP
- [ ] State tracked and saved

### Quest System Core

- [ ] Quest state machine: UNAVAILABLE → AVAILABLE → ACTIVE → COMPLETE / FAILED / CANCELLED
- [ ] Quest manager: tracks all quest states, fires events on state change
- [ ] Arma task integration: `BIS_fnc_taskCreate` for each active quest (map markers, HUD)
- [ ] Task state updates via `BIS_fnc_taskSetState`
- [ ] All quest states serialized for save/load

---

## UI & HUD

### Field HUD (Always Visible)

- [ ] Operation timer (when active)
- [ ] CP balance
- [ ] Active quest/objective indicator (current task name + direction)
- [x] Notification toast system (CP earned, objective updated, sector liberated)

### TOC Menus

- [ ] **Strategic Map:** shows Abdera sector, status, start operation button
- [ ] **Squad Menu:** spawn/despawn squad members, view/change loadouts (basic — full loadout editor not needed for POC, even just a preset selector)
- [ ] **FIA Upgrades:** show 1 upgrade, spend CP button, grey out if insufficient CP
- [ ] **Campaign Overview:** current sector status, CP balance, fail counter, FIA level

### Action Menu (Field)

- [ ] 1 working support call (e.g., mortar fire on map-clicked position) — proves the support call pipeline works
- [ ] Squad command (basic: regroup, hold position) — can use vanilla Arma commanding if not building custom

### Diary/Codex

- [ ] 1 diary subject for notifications (auto-populated on events)
- [ ] 1 briefing entry for the current operation
- [ ] 1 codex entry (e.g., "FIA" faction description) — proves the codex population system works

---

## Audio & Atmosphere

- [ ] 1 ambient sound source near Abdera (distant gunfire or machinery)
- [ ] Radio message on key events: operation start, operation complete, sector liberated (text + `say3D` or `playSound3D` radio static)
- [ ] Music: 1 exploration track, 1 combat track, auto-switch based on `player knowsAbout` or combat detection
- [ ] Combat supporting: death sounds on AI (vanilla handles this, verify it's working)
- [ ] Verify: music transitions don't cut abruptly, radio messages don't overlap

---

## Difficulty

- [ ] AI skills applied per faction on spawn (from config values)
- [ ] Difficulty slider: 3 levels stored as multiplier, applied to base skill values
- [ ] Slider accessible from settings/TOC (even a simple action "Set Difficulty" cycling 1/2/3 for POC)
- [ ] Verify: changing difficulty mid-game affects newly spawned AI
- [ ] Verify: skill differences are noticeable (FIA loses fights without player, player squad is effective but not dominant)

---

## Counter-Attack System (Simplified for POC)

- [ ] Timer starts after sector liberation (90 min real time)
- [ ] On timer: probability roll (e.g., 50% chance)
- [ ] If triggered: AAF assault force spawns and attacks liberated sector
- [ ] Player warned via radio message 5-10 minutes before attack
- [ ] If FIA defenders + player repel attack: sector stays liberated
- [ ] If defenders fail (all FIA dead, flag recaptured): sector reverts to CONTESTED
  - [ ] HUMINT missions in sector become unavailable
  - [ ] FIA camp removed or reduced
- [ ] Counter-attack force despawns after resolution (win or lose)
- [ ] Verify: counter-attack spawns within AI budget (despawn distant AI if needed to make room)
- [ ] **Disable counter-attacks during tutorial/first operation** — only starts after first liberation

---

## Integration Tests (End-to-End)

These prove the full loop works as a connected experience.

- [ ] **Fresh start → tutorial → TOC:** New game, tutorial plays, player reaches TOC, save works
- [ ] **Secondary objective → operation → liberation:** Complete secondary obj, start operation, complete operation, sector liberates, CP awarded
- [ ] **Post-liberation content spawns:** HUMINT appears, FIA Support Op appears, FIA camp spawns
- [ ] **HUMINT → CP → upgrade:** Complete HUMINT, earn CP, return to TOC, spend CP on upgrade, effect applies
- [ ] **FIA Support Op → CP:** Complete support op, earn CP
- [ ] **Save/Load cycle:** Save at TOC with all progress, quit, reload. All states restored: sector liberated, CP balance, quest states, FIA camp present, upgrade applied
- [ ] **Counter-attack:** Wait for counter-attack timer, receive warning, fight or ignore. Sector state updates correctly.
- [ ] **Counter-attack loss:** Let counter-attack succeed. Sector reverts, HUMINT locked, FIA camp affected.
- [ ] **Operation failure:** Intentionally fail operation, verify fail counter increments, verify restart works
- [ ] **Player death:** Die in open play, verify respawn at TOC, verify squad present, verify world state unchanged
- [ ] **Performance baseline:** Run full POC scenario, note FPS at: TOC, approaching sector, mid-combat, post-liberation town. All should be above 30 FPS.

---

## Out of Scope for POC

Do NOT build these yet. They add complexity without validating core systems.

- ~~Multiple operation approaches (1 approach is enough)~~
- ~~PMC locations and intel chain~~
- ~~Collection objectives (bunkers, caches, hostages)~~
- ~~NATO base deployment~~
- ~~Multiple support asset types (1 is enough to prove the pipeline)~~
- ~~Full loadout editor (preset selector is fine)~~
- ~~NPC dialogue system~~
- ~~Ambient civilians~~
- ~~Ambient battles (sound only is fine)~~
- ~~Full codex population~~
- ~~Multiple HUMINT mission types (1 type is enough)~~
- ~~Vehicle systems (fuel, damage, storage)~~
- ~~CSAT forces (AAF only for sector 0)~~
- ~~Full notification/diary integration~~

---

## Definition of Done

The POC is complete when a player can:

1. Start a new game and play through the tutorial
2. Arrive at TOC and understand available actions
3. Optionally complete a secondary objective
4. Start and complete (or fail) the Abdera operation
5. See the sector liberate and world state change
6. Complete a HUMINT mission and a FIA Support Op
7. Earn and spend CP on one upgrade
8. Save the game, quit, reload, and have everything intact
9. Experience a counter-attack threat on the liberated sector
10. Feel like the core loop is fun and worth expanding