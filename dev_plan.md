# OPERATION SOVEREIGN FURY
## Green Beret ODA — Unconventional Warfare Campaign
### Development Plan & Technical Specification

**Version 1.0 — March 2026**

| Parameter | Value |
|-----------|-------|
| Setting | Altis, 2020s |
| Enemy Faction | CSAT Conventional Forces |
| Player Role | 12-member Green Beret ODA |
| Campaign Arc | Unconventional → Full Spectrum Warfare |
| Technical Stack | Eden Editor + HBQ Spawn + Drongos + Custom SQF |

---

# PART ONE: Full Project Development Plan

## Development Phases Overview

The project is divided into five sequential phases. Each phase builds on the previous and produces a testable deliverable. Do not advance to the next phase until the current one is stable and playtested.

| Phase | Focus | Deliverable | Est. Duration |
|-------|-------|-------------|---------------|
| Alpha | Core framework, single sector loop | Playable tutorial sector | 3–4 weeks |
| Beta | Multi-sector, operations, progression | 3–4 connected sectors | 4–6 weeks |
| Gamma | Full map build-out, content pass | All sectors playable | 6–10 weeks |
| Delta | Polish, balancing, UI, audio | Feature-complete build | 3–4 weeks |
| Epsilon | QA, playtesting, release prep | Release candidate | 2–3 weeks |

---

## Phase Alpha — Core Framework & Single Sector Loop

Goal: Build every core system in isolation and integrate them into a single playable sector. This phase produces the tutorial sector and validates that the fundamental game loop works before any content scaling begins.

### A1. Project Foundation

- Set up mission folder structure, description.ext, and init.sqf with modular script loading
- Configure HBQ spawn modules with basic enemy garrison in a test zone
- Configure Drongos modules for one air support and one artillery support asset
- Build a prototype TOC area with placeholder objects and interaction triggers
- Implement a global game state namespace storing sector status, ODA roster, asset inventory, and operation failure counter

**Validation:** Player spawns at TOC, can interact with objects, enemies spawn via HBQ in a nearby area.

### A2. ODA & Squad Management

- Create 12 ODA unit definitions with names, roles, and passive bonus variables
- Build squad selection interface at the TOC allowing the player to add or remove any ODA member
- Implement passive bonus system: when a specialist is in the active squad, apply the relevant modifier (e.g., comms sergeant reduces support call-in delay, medic enables auto-revive proximity check)
- Build incapacitation system: on ODA member death event, switch to 30-minute incapacitated state with visible timer, require player interaction with medkit for up to 3-minute revive
- Build medic auto-revive: if an ODA medic is in proximity of an incapacitated member, trigger scripted revive action with animation
- Build replacement pipeline: on permanent death, mark slot as pending, spawn replacement after 6 real-time hours

**Validation:** Take ODA members on patrol, one gets incapacitated, revive with medkit, confirm passives apply, confirm permanent death after timer expiry.

### A3. Sector Control System

- Define sector data structure: unique ID, display name, boundaries (trigger area or marker), POI position, status (occupied/contested/liberated), adjacency list, command points capacity, assigned militia array
- Build sector status manager that updates status based on adjacency to liberated sectors
- Build the capture mechanic: player must clear and hold the sector POI to flip status
- Implement enemy respawn logic for occupied sectors via HBQ — units replenish outside player view until sector is captured
- Build map markers that update dynamically based on sector status (color-coded: red occupied, yellow contested, green liberated)

**Validation:** Capture the tutorial sector POI, confirm status flips to liberated, confirm markers update, confirm enemy respawns stop.

### A4. Militia System

- Build command point allocation interface at the TOC showing available points per liberated sector
- Define militia type matrix: specialties (infantry, anti-tank, anti-air, mortar, technical) combined with roles (patrol, static defense)
- Implement militia spawning: on allocation, spawn appropriate AI units at role-determined positions within the sector
- Militia configurations are locked once placed — points must be freed by dismissing units before reallocation

**Validation:** Liberate tutorial sector, allocate command points, confirm militia spawn at correct positions with correct loadouts.

### A5. Counterattack System

- Build counterattack trigger system: timed evaluation loop checking sector importance, surrounding sector status, and total enemy-held sectors
- Implement announcement mechanic: notification to player with direction of attack, target sector, and countdown timer
- Build wave spawner: 1 to N waves of enemies approaching the sector POI, scaling in size based on sector importance
- Implement sector loss condition: if enemies hold the POI through all waves, sector reverts to occupied and all militia and infrastructure are lost
- Player must physically retake the sector following the normal capture flow

**Validation:** Trigger a test counterattack on tutorial sector, confirm waves spawn and approach POI, confirm sector flips if undefended, confirm recapture works.

### A6. Save System Stress Test

This is a critical validation step before building more content. Test the following save-load scenarios in the tutorial sector:

1. Save with active incapacitation timer running, reload, confirm timer state
2. Save with militia deployed via command points, reload, confirm militia still present and command points correctly allocated
3. Save with sector in liberated state, reload, confirm status persists and enemies do not respawn
4. Save mid-counterattack with waves active, reload, confirm counterattack state
5. Save with ODA member in replacement pipeline, reload, confirm timer and slot status

*If any of these fail, implement a profileNamespace-based persistence layer that serializes critical game state variables on manual save and restores them on mission load. Do this now, not later.*

---

## Phase Beta — Multi-Sector, Operations & Progression

Goal: Expand from one sector to three or four connected sectors. Build the operation system, side objective framework, progression unlocks, and the full game loop from recon to liberation. This phase validates that the campaign structure works across multiple sectors.

### B1. Sector Expansion

- Hand-build 2–3 additional sectors adjacent to the tutorial sector along the northwest coast of Altis
- Each sector needs: defined boundaries, POI, HBQ spawn module configuration, hand-placed enemy bases and fortifications, adjacency links to neighboring sectors
- Vary sector size and command point capacity to test the scaling system
- Test adjacency logic: confirm that sectors behind occupied territory only allow side objectives, not the full operation

### B2. Intel & Recon System

- Place strategic question mark markers in contested and occupied sectors at locations of interest
- Build the scouting reveal mechanic: player physically approaches a question mark location, trigger area detects presence, question mark resolves into a specific side objective marker with details
- Implement the ISR request at the TOC: one-time per sector script that reveals all side objective markers at once, available after a specific operation is completed
- Set up the physical radar object at the TOC using Arma's native radar system to display enemy radar-based positions

### B3. Side Objective Framework

Build a modular side objective system where each objective is a self-contained script triggered by the player. Side objective types to implement:

- **Destroy AA Emplacements:** Player locates and destroys anti-air assets. On completion, flags the sector's AA as neutralized for the operation.
- **Clear Minefields:** Player identifies and clears mined areas. On completion, removes minefield hazards from the operation zone.
- **Disable Artillery:** Player raids and destroys enemy artillery positions. Prevents enemy fire support during the operation.
- **Destroy Radar Installation:** Player sabotages enemy radar. Reduces enemy detection capability during the operation.
- **Eliminate HVT:** Player assassinates a high-value target. Degrades enemy command and control.
- **Rescue Prisoner:** Player extracts a friendly prisoner. Potentially adds a militia recruit or provides bonus intel.
- **Destroy Supply Cache:** Player locates and destroys logistics. Reduces enemy reinforcement strength during the operation.
- **Gather Intel Documents:** Player infiltrates a location and retrieves documents. Reveals additional information about the operation.

Each completed side objective sets a flag that the operation system reads to adjust enemy force composition, asset availability, or allied force strength.

### B4. Operation System

- Build operation trigger via the interactive Arma 3 map: player opens map at TOC, selects a contested sector, and initiates the operation
- Implement pre-operation setup script: spawns allied AI forces (militia and spec ops for early game), positions the ODA at the insertion point, transitions to briefing screen
- Build briefing screen with map overview and optional voiceover placeholder
- Implement allied AI force pool: a unit counter that depletes as friendlies are killed. If the pool hits zero, the operation fails regardless of ODA status
- Operation success condition: ODA completes its assigned objective (varies by sector)
- Operation failure condition: ODA objective fails or allied force pool is depleted. Increment global failure counter. At 3 failures, trigger game over
- On success: sector flips to liberated, remaining allied AI despawns when player is out of view, unlock trigger fires
- Build the side objective modifier system: read completion flags and adjust operation parameters accordingly (remove AA units, reduce enemy count, boost allied pool, etc.)

### B5. Progression & Unlock System

- Define unlock table: a data structure mapping each completed operation to the gear, vehicles, support assets, and outfit options it unlocks
- Build TOC requisition interface: player requests available assets from a physical object at the TOC. Non-AI assets (ground vehicles, drones, explosives, launchers) are spawned at a designated pad or crate
- Implement vehicle respawn limits: each high-value asset has a maximum spawn count (e.g., Apache: 1–3 total spawns). Track usage globally
- Build outfit management: player accesses arsenal for personal loadout. Squad members have preset style options selectable via interface (default US Army, militia, night ops, civilian ops)
- Implement TOC relocation: after specific operations, new TOC locations unlock. Player can choose to move TOC to one of three positions as they push inland

### B6. Phase Escalation Framework

Implement the three-phase campaign escalation that controls what allied forces and assets are available during operations:

- **Early game (sectors 1–4):** Militia and US special operations forces only. Limited vehicle and support assets. Player relies heavily on asymmetric tactics.
- **Mid game (sectors 5–8):** Militia, spec ops, plus specialized conventional units: Rangers, Airborne, attack aviation. Heavier support assets unlock.
- **Late game (sectors 9+):** Full spectrum conventional warfare. Armor, mechanized infantry, fixed-wing CAS, naval fire support. Operations are large-scale combined arms battles.

Tie escalation triggers to operation completion count or specific key sector liberations.

---

## Phase Gamma — Full Map Build-Out

Goal: Expand to the full Altis map with all sectors, operations, and side objectives built. This is the longest phase and primarily content creation work.

### C1. Sector Map Design

Design the full sector layout across Altis. Recommended approach:

- 10–15 total sectors to keep each one hand-crafted and distinct while providing 40–60+ hours of campaign content
- Map the adjacency graph on paper first: ensure multiple viable push paths from any coastline
- Vary sector themes: urban, industrial, airfield, port, rural, mountainous, coastal fortification
- Assign each sector: difficulty tier, command point capacity, operation type, side objective set, and phase escalation bracket

### C2. Sector Construction Pipeline

For each sector, follow this build sequence:

1. Define boundaries, POI location, and adjacency links in the sector data structure
2. Hand-build the sector in Eden: enemy bases, fortifications, patrol routes, ambient objects, atmosphere
3. Configure HBQ spawn modules for enemy garrison and respawn behavior
4. Place question mark markers for side objective scouting locations
5. Script each side objective (reuse modular templates from Phase Beta, customize per sector)
6. Build the operation: allied force composition, ODA objective, briefing, success/fail conditions
7. Define operation unlock rewards: new gear, vehicles, support, TOC relocation if applicable
8. Configure counterattack parameters: frequency, wave count, approach directions
9. Playtest the sector end-to-end in isolation before integrating

### C3. Operation Variety

Each sector's operation should feel distinct. Operation types to vary across the campaign:

- Airfield seizure: ODA marks targets for air assault while Rangers secure the runway
- Port capture: amphibious assault with ODA clearing AA positions ahead of the main landing
- Urban clearance: ODA provides overwatch and marks enemy armor for CAS while infantry pushes through
- Bridge assault: ODA prevents demolition while engineers secure crossing points
- Mountain stronghold: ODA infiltrates and disables comms/radar while airborne forces assault
- Final offensive: full combined arms operation with ODA coordinating multiple elements

### C4. Enemy Escalation

CSAT forces should escalate as the player pushes deeper inland:

- Coastal sectors: light infantry, technicals, static emplacements, no armor
- Mid-island sectors: mechanized infantry, APCs, AA systems, rotary wing patrols
- Interior and key objectives: main battle tanks, integrated air defense, attack helicopters, fortified positions
- Counterattack intensity scales with total enemy sectors lost — as CSAT gets cornered, they fight harder

---

## Phase Delta — Polish, Balancing & UI

Goal: Bring the feature-complete build to release quality. This phase focuses on feel, balance, and presentation.

### D1. Balance Pass

- Tune counterattack frequency and wave size per sector so they feel threatening but not exhausting
- Balance command point economy: ensure the player can't trivially garrison every sector but can hold critical ones
- Calibrate operation difficulty with zero, partial, and full side objective completion to ensure all three are meaningfully different
- Test the 3-failure game over threshold across full campaign playthroughs — confirm it's firm but fair
- Balance vehicle respawn limits: too generous removes tension, too punishing discourages use

### D2. TOC & Interface Polish

- Finalize all TOC interaction objects with clear visual language (distinct objects for squad management, militia, requisition, map, intel)
- Polish the interactive map: sector status colors, operation availability indicators, side objective tracking, counterattack warnings
- Add briefing screens with map overlays for each operation
- Implement notification system for counterattack warnings, ODA member status changes, asset availability, and sector status updates

### D3. Audio & Atmosphere

- Add ambient audio per sector type (urban, rural, coastal, mountainous)
- Record or source voiceover for operation briefings if planned
- Add radio chatter during operations for allied AI forces to sell the larger battle
- Implement music triggers for key moments: operation launch, sector liberation, counterattack warning, game over

### D4. Intro & Narrative

- Build the mission introduction: insertion sequence, initial briefing establishing context
- Write text briefings for each sector and operation providing narrative context
- Build the game over screen and victory screen with campaign statistics

---

## Phase Epsilon — QA, Playtesting & Release

Goal: Validate the complete campaign experience and prepare for release.

### E1. Full Campaign Playtests

- Play through the entire campaign start to finish at least three times using different push paths across the map
- Test aggressive play: skipping side objectives and attempting operations underprepared
- Test cautious play: completing every side objective before each operation
- Test attrition: deliberately losing ODA members and assets to confirm the campaign remains completable

### E2. Save System Validation

- Save and reload at every phase of the game loop: mid-recon, mid-side objective, pre-operation, mid-operation, during counterattack, at TOC
- Confirm all game state survives: sector statuses, militia deployments, ODA roster, asset counters, operation failure count, progression unlocks

### E3. Performance

- Profile FPS in late-game scenarios with multiple liberated sectors, militia deployed, and a large-scale operation running
- Verify HBQ despawning is working correctly to manage unit count
- Stress test the worst case: maximum militia deployed, counterattack in progress, operation launching simultaneously

### E4. Release Preparation

- Write Steam Workshop description with feature list, requirements, and credits
- Capture screenshots and trailer footage
- Document any mod dependencies clearly
- Package and upload

---

# PART TWO: First Sector Implementation Guide

## Tutorial Sector — Northwest Altis

### Purpose & Design Goals

The tutorial sector serves three purposes: teach the player every core system, validate all technical systems under real gameplay conditions, and provide a satisfying self-contained experience that hooks the player into the full campaign. It must be small enough to complete in 60–90 minutes but comprehensive enough to exercise every mechanic.

### Recommended Location

The northwest tip of Altis around the area of Therisa or the small coastal settlements near grid 03–04. This area offers a mix of light urban structures, open terrain, and coastal access for the insertion narrative. It is isolated enough to feel contained but has natural sight lines and terrain features that create interesting tactical situations.

### Sector Specifications

| Parameter | Value |
|-----------|-------|
| Sector ID | sector_tutorial_nw |
| Status at Start | Contested (only sector available) |
| Approx. Size | 800m x 800m playable area |
| Command Points | 4 (enough for 2–3 militia groups) |
| Enemy Strength | Light infantry only: 20–30 CSAT in 3–4 groups |
| Side Objectives | 2 (one combat, one recon/intel) |
| Operation Type | Small-scale assault with militia + ODA |
| POI | Small CSAT command post or comms facility |
| Unlocks on Completion | Full map reveal, 2nd sector available, basic vehicle access |

---

### Step 1: Mission Foundation

**Estimated time: 2–4 hours**

**Build:**

- Create new mission in Eden on Altis. Set up description.ext with mission name, author, respawn settings (respawn = 3 for instant respawn disabled), and onLoadMission text
- Create init.sqf with modular script compilation using compileFinal and CfgFunctions where appropriate
- Set up a global namespace object or series of missionNamespace variables for game state: ODA roster array, sector status hashmap, asset inventory array, operation failure counter (starting at 0), and campaign phase variable (starting at 1 for early game)
- Place the player unit in the northwest area of Altis as a BLUFOR special forces unit

**Validate:** Mission loads without errors. Player spawns at correct location. Global variables initialize and can be read via debug console.

---

### Step 2: TOC Construction

**Estimated time: 3–5 hours**

**Build:**

- Place TOC objects at the northwest coastal area: a tent or small structure as the command center, a table for the interactive map, a crate for arsenal access, a board or laptop for squad management, a radio for support asset requests, and a separate object for militia management
- Add addAction interactions to each object with placeholder text confirming what system it will open
- Build the squad management interface: display all 12 ODA members with name, role, status (active, standby, incapacitated, KIA/pending replacement), and a toggle to add or remove from active squad
- Spawn all 12 ODA members as AI units at the TOC. Active squad members join player's group. Standby members remain at TOC with animations

**Validate:** All TOC objects have working interactions. Squad management interface displays all 12 members. Adding a member to active squad causes them to join the player's group. Removing returns them to TOC.

---

### Step 3: ODA Combat Systems

**Estimated time: 4–6 hours**

**Build:**

- Implement the incapacitation event handler: on any ODA member's death event, cancel the death, switch to incapacitated state (setUnconscious true, or custom ragdoll), start 30-minute countdown displayed on HUD
- Build the medkit revive interaction: when player is near an incapacitated ODA member and has a medkit, addAction to revive with a 3-minute progress bar and animation lock
- Build the medic auto-revive: if an ODA medic is within 15 meters of an incapacitated member, trigger automatic scripted approach and 3-minute revive
- Implement permanent death: if 30-minute timer expires, unit is permanently killed. Mark roster slot as pending replacement with 6-hour real-time timer
- Implement passive bonus system: define a hashmap of role-to-bonus mappings. On squad composition change, recalculate active bonuses. Starter bonuses to implement: medic (enables auto-revive), comms sergeant (reduces Drongos support cooldown by a percentage), marksman (increases AI squad accuracy slightly)

**Validate:** Shoot an ODA member (via debug). Confirm they go incapacitated, timer appears, medkit revive works, medic auto-revive triggers if applicable. Let timer expire on one, confirm permanent death. Confirm passive bonuses apply and update when squad composition changes.

---

### Step 4: Enemy Sector Build

**Estimated time: 4–6 hours**

**Build:**

- Design the tutorial sector layout in Eden: define the sector boundary using a trigger or area marker. Place the POI — a small CSAT command post with sandbags, a comms tower, and a few structures
- Hand-place atmospheric objects throughout the sector: checkpoints on roads, vehicle wrecks, propaganda posters, civilian structures showing occupation
- Configure HBQ spawn modules: 3–4 enemy groups of 5–8 CSAT light infantry. Set spawn radius, activation distance, and despawn behavior
- Create patrol waypoints for enemy groups: at least one roving patrol, one static garrison at the POI, and one or two groups at secondary positions
- Place 2 question mark markers at locations where side objectives will be scouted

**Validate:** Walk into the sector. Enemies spawn via HBQ at expected positions. Patrols follow routes. POI garrison is in defensive positions. Question marks are visible on map. Atmosphere feels like an occupied zone.

---

### Step 5: Sector Capture Mechanic

**Estimated time: 2–3 hours**

**Build:**

- Create a trigger zone at the POI that checks for enemy presence and player/friendly presence
- Implement capture logic: when no enemies are alive within the POI trigger zone and the player or friendly forces are present, begin a capture timer (60–90 seconds) with HUD indicator
- On capture completion: update sector status from contested to liberated, disable HBQ respawning for the sector, update map markers, trigger a notification to the player
- If enemies re-enter the POI during capture, pause or reset the timer

**Validate:** Clear all enemies from POI. Capture timer starts. Stand in zone until complete. Sector flips to liberated. Map marker updates. HBQ stops spawning enemies. Leaving and returning doesn't reset liberated status.

---

### Step 6: Militia Deployment

**Estimated time: 3–4 hours**

**Build:**

- Build the militia management interface accessible from the TOC militia object: shows the liberated sector with its command point total and current allocation
- Implement allocation workflow: player selects specialty (infantry, anti-tank), then role (patrol, static defense), then confirms. Points are deducted and units spawn
- Patrol militia: spawn on a patrol route within the sector with looping waypoints
- Static defense militia: spawn at the POI or predefined defensive positions with hold waypoints and defensive stance
- Implement deallocation: player can dismiss militia groups to free command points, dismissed units are deleted

**Validate:** Liberate tutorial sector. Open militia interface. Allocate infantry patrol — confirm units spawn on patrol route. Allocate static defense — confirm units hold position at POI. Exceed command points — confirm allocation is rejected. Dismiss a group — confirm points return.

---

### Step 7: Counterattack Test

**Estimated time: 3–4 hours**

**Build:**

- Build the counterattack evaluation script: for the tutorial sector, trigger a counterattack on a timer shortly after liberation (e.g., 10–15 minutes, reduced from normal for testing)
- Implement announcement: notification appears with estimated time to attack, direction of approach, and target sector name
- Spawn 1–2 waves of CSAT infantry approaching the POI from the announced direction, using SAD/DESTROY waypoints targeting the POI area
- Implement sector loss: if all defenders at the POI are eliminated and enemies hold the zone for 60 seconds, sector reverts to occupied. Militia are deleted. HBQ respawning re-enables
- Player must then recapture using the standard capture mechanic

**Validate:** Liberate sector, deploy militia, wait for counterattack announcement. Waves arrive from announced direction. If militia holds: sector stays liberated. If militia is overrun: sector reverts. Recapture works normally.

---

### Step 8: Side Objectives

**Estimated time: 4–6 hours**

**Build:**

Implement two side objectives for the tutorial sector:

- **Side Objective 1 — Destroy AA Emplacement:** Player scouts the first question mark, which reveals a ZSU or static AA position guarding the approach to the POI. Player must destroy it. On completion, set a flag that the operation reads to remove AA threats from the allied approach route.
- **Side Objective 2 — Gather Intel Documents:** Player scouts the second question mark, revealing a small outpost with a laptop or document case. Player must infiltrate (or assault), interact with the object, and extract. On completion, reveal enemy positions on the map for the operation and provide a bonus to allied AI awareness.

Build the scouting trigger: when player enters a 50–100 meter radius of a question mark, play a short notification, replace the question mark with the actual objective marker and task description.

**Validate:** Approach first question mark. It resolves to the AA objective with task description. Destroy the AA. Confirm completion flag is set. Approach second question mark. It resolves to intel objective. Interact with document object. Confirm completion flag is set. Check that both flags are readable by the operation system.

---

### Step 9: Tutorial Operation

**Estimated time: 5–8 hours**

**Build:**

- Build the operation trigger on the interactive map at the TOC: when player selects the tutorial sector and confirms, begin operation setup
- Setup script: spawn a small allied force (8–12 militia fighters, 4 spec ops AI) at a staging position. Teleport or transport the ODA to the insertion point
- Display a briefing screen: map overview showing the objective, known enemy positions (if intel side objective completed), allied approach route, and ODA tasking
- ODA tasking for this operation: advance to the POI and eliminate the CSAT command post garrison while allied militia provides a supporting assault from a different axis
- Allied AI force pool: set a total unit count (e.g., 15). As friendlies are killed, decrement. If pool hits zero before objective completion, operation fails
- Read side objective flags: if AA was destroyed, do not spawn AA threat along the allied approach. If intel was gathered, spawn enemies in known positions with reduced skill or numbers
- Success condition: all enemies at the POI command post are eliminated while at least one ODA member is alive
- On success: play liberation notification, update sector to liberated (if not already), despawn remaining allied AI when player is out of view, trigger progression unlock (full map reveal, next sectors become available, first batch of gear and vehicle unlocks)
- On failure: increment failure counter, return player to TOC, allow retry

**Validate:** Run the operation with both side objectives complete — should be manageable. Run it again (via debug reset) with zero side objectives complete — should be noticeably harder, with AA threatening allies and more/tougher enemies. Confirm failure increments counter. Confirm success unlocks progression.

---

### Step 10: Integration & Save Testing

**Estimated time: 3–4 hours**

No new systems. This step is pure integration testing and save validation.

**Test the complete loop:**

1. Start fresh. Spawn at TOC. Manage squad — select 4–6 ODA members.
2. Move to sector. Scout question marks. Complete both side objectives.
3. Return to TOC. Trigger the operation. Complete it successfully.
4. Sector liberates. Deploy militia via command points.
5. Wait for counterattack. Defend or let militia handle it.
6. Confirm full map reveals and next sector becomes available.

**Save and reload at each of the following points:**

1. After squad selection at TOC, before leaving
2. Mid-side objective with enemies engaged
3. After side objectives complete, before operation
4. During the operation with allied AI active
5. After liberation with militia deployed
6. During a counterattack with waves spawning

*Document every save-load failure. If critical state is lost, build the profileNamespace persistence layer before proceeding to Phase Beta.*

---

## Risk Register

| Risk | Impact | Mitigation |
|------|--------|------------|
| Save system breaks scripted state | Players lose progress, game becomes unplayable across sessions | Test early in Phase Alpha. Build profileNamespace fallback. |
| Arma AI pathfinding in operations | Allied forces get stuck, break immersion, fail to support the player | Use simple waypoints, open terrain for AI movement. Pre-test every operation path. |
| Performance with many sectors active | FPS drops make late-game unplayable | HBQ despawning, limit concurrent active militia, profile regularly. |
| Scope creep | Project never finishes | Fix sector count early. Ship the tutorial sector as a proof of concept if needed. |
| Unwinnable campaign state | Player hits soft lock without realizing due to attrition | Test worst-case attrition. Consider a warning system when resources are critically low. |
| Counterattack fatigue | Constant defense interrupts the fun offensive loop | Tune frequency carefully. Consider a cooldown after recent counterattacks. |