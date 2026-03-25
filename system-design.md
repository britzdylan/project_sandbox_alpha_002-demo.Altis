# Domain Analysis — Full Board Review

---

## 1. AI & Factions

### What You Have

- **NATO:** Green Beret ODA, USMC 31st MEU, US Army SOCOM (Task Force Bruiser)
- **FIA:** Local guerrilla force, friendly to NATO
- **AAF:** Enemy to BLUFOR, OPFOR ally, bulk force on island, Mechanized Btn, Parachute Btn
- **CSAT:** Enemy to BLUFOR, C2 structure, Heavy Brigade, tech advanced, air units, naval units
- **PMC:** Neutral force, infrastructure security, 1 Security Group, smuggling women, crackdown mission with SBS

### Feedback

**The faction lineup is strong.** Five factions with distinct roles gives the world genuine political texture. The PMC as the hidden villain with the human trafficking angle adds a dark layer that differentiates this from a generic liberation scenario.

**The AAF is underspecified compared to the others.** They're your primary enemy for most of the game (bulk force on island) but you've given them the least personality. "Mechanized Btn" and "Parachute Btn" tells me their ORBAT but not their behavior. Do they have a command structure that degrades as you take sectors? Do patrols get more aggressive as you push deeper? Does the Parachute Btn counter-attack differently than the Mechanized Btn? The AAF needs behavioral variety, not just unit variety, or every sector will feel the same to fight.

**CSAT's naval and air presence is a scope trap.** Naval combat in Arma 3 is extremely limited. Air units as an active opponent are performance-expensive (AI pilots flying are costly) and balance-breaking (the player has no good counter early game). Recommendation: make CSAT's naval/air presence a narrative backdrop (carrier offshore, jets doing flyovers that can't be engaged) rather than active gameplay. Reserve actual air threats for specific operations at higher levels where the player has unlocked AA support.

**PMC as neutral is interesting but needs clear rules.** When does the player discover they're trafficking? Before the SBS crackdown mission or as part of it? If the player shoots PMC guards before the reveal, what happens? You need a "PMC hostility trigger" defined — are they always neutral until a specific story beat flips them? Can the player accidentally start a fight?

**Missing: faction strength decay.** As you liberate sectors, does the AAF get weaker globally? Fewer patrols? Worse equipment? Or do they always spawn at full strength in unliberated sectors? Global attrition would make liberation feel like it matters beyond the individual sector.

**Missing: BLUFOR presence escalation.** You have NATO units listed but no description of how their presence grows. Early game it's just the player and FIA. When do NATO units start appearing? Is it tied to CP spending ("Deploy NATO bases") or story progression? Both?

---

## 2. Audio & Atmosphere

### What You Have

- **Ambient Sounds:** Radio chatter, machinery, distant battles, ambient fly-bys, broadcasts
- **Music:** Undecided (?)
- **Radio Messages:** Key narrative radio messages, main form of storytelling, narrative without cutscenes
- **NPC Dialogs:** NPCs talking to each other triggered by player presence
- **Combat Supporting Sounds:** Screams and death sounds

### Feedback

**Radio as primary narrative delivery is a great choice for Arma.** It's diegetic, doesn't break gameplay, and is cheap to produce compared to cutscenes. This was the right call.

**Music being undecided is fine for now** but don't leave it for last. A combat music state machine (explore → tension → combat → aftermath) is easy to build technically and massively impacts feel. Even placeholder tracks from Arma's built-in music library will tell you if your pacing works. Decide early if music is state-driven (auto-switches based on combat) or event-driven (specific tracks for specific operations). State-driven is more work but better for open-world.

**"Distant battles" as ambient sound is excellent.** This is one of the best tricks for making a warzone feel alive. `playSound3D` positioned 1-2km away with randomized artillery/gunfire creates a sense of a larger conflict. Cheap to implement, high impact.

**NPC dialogs triggered by player presence could become a performance concern.** If you're spawning civilians in liberated towns AND having them run dialogue scripts on proximity triggers, that's AI + scripting overhead in areas the player frequents. Keep the dialogue system lightweight — `say3D` with pre-recorded lines on a cooldown timer, not a full conversation simulation.

**Missing: UI feedback sounds.** You have combat audio covered but nothing for RPG actions — CP earned, FIA level up, objective complete, support asset ready. These audio cues are critical for game feel. A "ding" when you earn CP, a radio confirmation when CAS is inbound, a notification sound for quest updates — small effort, huge polish.

---

## 3. Codex / Diary

### What You Have

- **Diary** with tabs: Notification Log, Briefing, Tasks, Map, Team, Codex
- **Codex** section with Help

### Feedback

**This is the right set of tabs.** The only question is whether you're building this as a custom UI or using Arma's built-in diary system (`createDiaryRecord`, `createDiarySubject`).

**Recommendation: use the built-in diary for most of this.** Arma's diary system already supports subjects (tabs), records (entries), and links. Notification Log, Briefing, and Tasks can all be diary subjects. You get free map integration (diary links can center the map on locations). The Map tab is already native. Team info can be a diary subject.

**The Codex as a help/lore system is good.** Populate it progressively — don't dump everything at game start. Add entries when the player encounters new factions, mechanics, or locations. This gives a sense of discovery and avoids information overload.

**Missing: auto-updating entries.** If the world state changes (sector captured, FIA upgraded), do diary entries update? Static entries become stale fast in a dynamic world. At minimum, the Briefing tab should reflect current world state.

---

## 4. Core Gameplay Loop (Updated)

### What Changed

The updated loop now shows "FIA Support Ops" as a distinct path alongside HUMINT feeding into the "Complete" diamond. This is clearer than the previous version.

### Feedback

The loop is maturing well. No new concerns beyond what we've already discussed. The addition of FIA Support Ops as a separate completion requirement (alongside HUMINT) adds more between-operation content, which addresses the pacing concern. Good.

---

## 5. Difficulty

### What You Have

- **Unit Skills:** FIA 0.3, AAF 0.3, Player squad 1.0, NATO Recon 0.8, NATO Regular 0.6, CSAT 0.5
- **Difficulty Slider:** Base + Level modifier, 3 levels

### Feedback

**FIA and AAF both at 0.3 is a problem.** The FIA are your allies and the AAF is your primary enemy for most of the game. At equal skill, FIA will trade evenly with AAF, which means the player is largely irrelevant to combat outcomes — friendly AI handles it. This undermines the power fantasy. The FIA should feel like they need you. Set FIA to 0.2-0.25 and AAF to 0.35-0.4. The gap matters more than the absolute values. The player should be the difference-maker, not a spectator.

**Player squad at 1.0 is too high.** At skill 1.0, your squad mates are essentially terminators — perfect aim, instant spotting, zero fear. They'll trivialize combat and steal kills constantly. Try 0.6-0.7 for the player's squad. Skilled enough to be useful, imperfect enough that the player is clearly the best soldier in the group.

**CSAT at 0.5 while AAF is at 0.3 is the right relationship** but consider that CSAT encounters should be rare and feel genuinely dangerous. 0.5 might even be low for what should be a tier-2 threat. Consider 0.55-0.65 for CSAT to make them noticeably scarier than AAF.

**"Base + Level" with 3 difficulty tiers is clean.** Implementation suggestion: make the base values the ones above, then the 3 levels apply a multiplier. Easy = 0.85x, Normal = 1.0x, Hard = 1.15x. This way you tune the base values once and the slider scales everything proportionally. Don't let the slider push values above 0.95 or below 0.15 — both extremes break the AI.

**Missing: what else does difficulty affect?** AI skill alone is one lever. Does difficulty change AI count per garrison? Patrol frequency? Counter-attack probability? Loot scarcity? Timer lengths on operations? Define this now or you'll have a difficulty slider that barely feels different between levels.

---

## 6. Economy

### What You Have

- **Command Points:** 1 CP per HUMINT mission, exactly enough CP earned = total you can spend
- **FIA Unit Pool:** Simple level 0-X, increases total pool of FIA units alive at one time

### Feedback

**"Exactly enough CP earned = total you can spend" is a tight economy.** This means the player cannot waste CP without consequences. Every spending decision is permanent and meaningful. That's good design IF the player understands the constraint. Make this very clear in the tutorial. Nothing is more frustrating than spending CP on the wrong upgrade and realizing there's no recovery.

**1 CP per HUMINT mission is simple but might be too flat.** If every HUMINT mission gives 1 CP regardless of difficulty or type, there's no reason to prioritize harder HUMINT missions over easy ones. Consider: some HUMINT missions award 2 CP but are riskier or more time-consuming. This creates an efficiency decision within the downtime phase.

**The FIA unit pool as a progression system is clever.** It directly ties investment into visible world change — more FIA units = busier liberated towns, stronger defences, more ambient support. This is the kind of progression that feels tangible rather than abstract. But define the pool ceiling. What's the maximum? 20 FIA units? 50? Your AI budget is the hard ceiling here. Every FIA unit alive is one fewer slot for enemies.

**Missing: is there any non-CP economy?** You previously mentioned loot from the core loop. Are weapons and gear from fallen enemies the only equipment source? Can you loot AAF/CSAT gear and use it? If so, that's a soft economy layer on top of CP — the player is resource-gathering during operations through looting. Worth defining explicitly.

**Missing: CP cost table.** You need a rough cost table now, even if numbers change. How much does each upgrade path cost at each tier? If the total CP available across all HUMINT missions is, say, 30, and all upgrades cost a total of 30, the player must complete every HUMINT mission to max everything. If upgrades total 45, the player must choose what to leave behind. That ratio defines the feel of the economy.

---

## 7. Environment

### What You Have

- **Terrain:** Altis (entire map)
- **Weather:** Dynamic
- **Time:** 6x multiplier
- **Ambient Life:** Abandoned vehicles, animals, civilians (foot/road/water), destroyed/vandalized towns, battlefield wrecks, ambient military activity, ambient battles
- **Environmental Hazards:** Minefields, restricted areas

### Feedback

**Altis entire map is ambitious but appropriate for a liberation game.** Altis is 270 km² — the largest vanilla terrain. This means you need a LOT of content to avoid empty stretches. Your sector system helps because it focuses the player's attention on specific areas, but the travel between sectors on an island this big can feel tedious.

**6x time multiplier means roughly 4 hours of daylight per real hour.** That's aggressive. The player will experience multiple day/night cycles per session. Make sure night operations are viable and interesting, not just "it's dark and annoying." Night should matter — reduced enemy spotting distance, different patrol behaviors, NVG availability tied to gear progression. If night doesn't change gameplay, consider 3-4x instead so the player gets longer daylight windows.

**The ambient life list is comprehensive and possibly too expensive.** Every item on that list is spawned objects eating performance. You're already running sector garrisons, patrols, FIA units, and the player's squad against an AI budget. Ambient civilians, ambient military activity, AND ambient battles on top of that will push you well past comfortable frame rates. Prioritize ruthlessly: ambient battles and military activity are high-impact but high-cost. Civilians and wrecks are low-cost atmosphere. Implement in tiers and test after each addition.

**Destroyed/vandalized towns is excellent world-building.** Use `setDamage` on buildings and spawn wreck compositions in liberated sectors to show the cost of war. Low performance cost, high atmosphere. Consider: towns get progressively repaired after liberation (composition swaps over time) to show FIA impact.

**Missing: does weather affect gameplay?** Dynamic weather is cosmetic unless you hook it into systems. Fog reducing AI spot distance, rain covering movement sounds, storms delaying helicopter support — these make weather a tactical consideration. Without these hooks, dynamic weather is just visual variety.

---

## 8. Locations

### What You Have

**Operations (hand-placed, randomly spawned):**
- Level 0: Abdera Airfield (spec ops outpost)
- Level 1: Frini Outpost, Molos Airfield, Gori Mill
- Level 2: Pyrsos Firebase, Sofia FOB, Feres Airfield
- Level 3: Xirolimni Dam, Chalkeia, Paros, AAC Airfield
- Level 4: Kavala, Charkia, Pyrgos
- Level 5: Airport

**Secondary Objectives:** Level 0 — Abdera Airfield, mine road, clear roadblock (available at start, optional)

**HUMINT Missions:** Level 0 — transport missing civilian to Oreokastro (available after liberation, increases FIA pool)

**FIA Locations:** Established after sector liberation, old spec ops outpost becomes camp, defences based on FIA level

**NATO Locations:** (empty)

**Opfor Fortifications:** DUMP checkpoint (keeps respawning until sector captured)

**PMC Restricted Areas:** Krya Nera (very dangerous, scout to learn more)

**FIA Support Ops:** Cache stash x3, counter logistics, steal equipment, increase influence (randomly selected after liberation, earn CP)

### Feedback

**The level progression across Altis makes geographic sense.** Starting in the northeast (Abdera) and pushing through the island toward the major cities and airport at the end is a natural escalation. The player moves from rural/remote to urban/fortified. Good.

**You have 16 operation locations across 6 levels.** That's a reasonable campaign length — roughly 16 major operations. With secondary objectives, HUMINT, and FIA support ops between each, you're looking at 40-60+ hours of content if each operation takes 30-60 minutes with downtime activities.

**"Hand-placed, randomly spawned" needs clarification.** Do you mean the locations are hand-placed on the map but the enemy compositions within them are randomly selected from a pool? Or that the locations themselves are randomly selected from a larger pool? The former is correct — hand-placed locations with randomized garrisons give consistency (the player learns the layout) with replayability (different enemy configs each attempt).

**Level 5 being just "Airport" feels underwhelming for a finale.** One location for the highest difficulty tier means the endgame is a single operation. Consider whether the airport should be a multi-phase operation (secure perimeter → clear runway → assault terminal → defend against counter-attack) rather than a single assault. The final operation should feel like the culmination of everything the player has built.

**Secondary objectives are thin.** You have three at Level 0 and nothing defined for higher levels. Each operation level should have its own secondary objectives. Level 2 might have "destroy artillery position" or "rescue captured FIA fighters." Level 4 might have "intercept CSAT resupply convoy" or "sabotage communications array." Without secondary objectives at higher levels, the difficulty-reduction mechanic from your core loop stops working.

**HUMINT has only one mission type defined.** "Transport missing civilian" is fine but you said these would be varied. You need at least 4-5 types: escort civilian, deliver medical supplies, clear minefield, investigate report, set up refugee camp. Define the types now even if you only build 2-3 initially.

**NATO locations are empty.** These matter because they represent the player's permanent investment. When you spend CP on "Deploy NATO bases," what appears? An FOB with NATO soldiers? A checkpoint? Does it have defences? Does it affect nearby patrols? Define this or the CP spending feels hollow.

**The PMC Restricted Areas (Krya Nera) need more locations.** One PMC location doesn't justify a dedicated quest chain about intel gathering. You need 3-4 PMC sites with intel fragments that combine into the reveal. Spread them across the map so the player encounters them naturally during the campaign.

---

## 9. Narrative

### What You Have

- **FIA:** Resistance to AAF, AAF defectors + civilians, almost destroyed, last fighters in Oreokastro, NATO approaches them to help in exchange for removing CSAT influence
- **NATO:** Wants to remove CSAT influence, partners with FIA, launches Operation Sovereign Fury, Carrier Strike Group 14, USMC 31st MEU, Task Force Aegis (SOCOM, 75th Rangers, Green Beret ODA 12, Delta Force, SBS)
- **CSAT:** Wants to spread influence in the gulf, backed AAF coup of corrupt government, provided training/equipment to AAF, main support in civil war, turned Altis into controlled naval base, controls the gulf
- **AAF:** Overthrew government, seized power permanently, reason for FIA resistance, got CSAT support, 1 Support + 1 Light Mechanized Btn (Airborne), crushed FIA in 6 weeks
- **PMC:** Unknown contract work, treaty to protect key infrastructure, neutral, secretly human trafficking ring, reason for SBS inclusion, paid off CSAT and AAF officials
- **CIV:** Most were killed, extremely poor and fearful, contained in Kavala and Pyrgos, small pockets elsewhere

### Feedback

**The geopolitical setup is coherent and grounded.** CSAT backing a military coup, NATO responding through proxy warfare with a local resistance — this is basically a fictionalized version of real-world interventions. It works because it's plausible.

**The PMC subplot is the most interesting narrative element.** A neutral faction that's secretly trafficking people, paying off both sides, hiding behind a security contract — this gives the player a genuine discovery arc. The SBS inclusion in Task Force Aegis as specifically because of the PMC trafficking is a nice detail that ties special operations to a moral purpose beyond "shoot the bad guys."

**The FIA backstory is solid but needs a face.** "Last fighters took refuge in Oreokastro" is a faction backstory. Who is the FIA leader? Who does the player report to? Who gives the radio briefings? A single named NPC as the FIA commander — with a voice, a personality, and opinions about the player's choices — transforms the faction from a game mechanic into a character.

**The AAF needs a villain.** Same issue. Who leads the AAF? Why did they coup the government beyond generic power seizure? A named antagonist who appears in radio intercepts, is referenced by captured intel, and possibly confronted in the final operation gives the campaign personal stakes.

**"Civilians — most were killed" is dark.** That's fine if you commit to the tone. But it means the HUMINT humanitarian missions carry real weight — you're not doing charity, you're trying to help survivors of a near-genocide. Make sure the tone of those missions matches. They shouldn't feel like fetch quests; they should feel somber.

**Missing: the player character.** Who is the player? Green Beret ODA team leader? A named character or a blank slate? Does the player have personal stakes beyond the mission? Even a sentence of backstory — "you lost contact with assets on Altis six months ago, this is personal" — gives the player a reason beyond following orders.

**Missing: narrative arc structure.** You have faction backstories but no story beats. When does the player learn about the PMC trafficking? When does CSAT escalate (bring in heavier units)? When does the player's success trigger a CSAT response? These beats should align with your operation levels: Level 1-2 is "establishing foothold," Level 3 is "CSAT notices and escalates," Level 4 is "PMC reveal," Level 5 is "final push." Map story to progression.

---

## 10. Persistence

### What You Have

**Single Player Respawn:**
- In open play: player dies, respawn at TOC
- Squad moves with you, unconventional AI gets killed

**Custom Save:**
- Saves important world state
- Can only save at TOC
- All spawned units respawned on load
- Moving units restart at starting positions
- Autosave at key points
- Reloading autosave starts player at TOC even though world state advanced

### Feedback

**Save only at TOC is a bold choice.** It makes the TOC feel important and adds weight to going into the field — you can't quicksave before risky moves. But it also means if the player spends 45 minutes doing HUMINT missions and field work, then dies, they lose all of it. That's punishing. The autosave at key points mitigates this IF "key points" are frequent enough. Define what key points are: start of operation, completion of HUMINT mission, sector liberated, return to TOC? If autosave only triggers at TOC visits, then saving at TOC only is meaningless.

**"All spawned units get respawned on load" is the right approach.** Don't try to save AI positions — it's not worth the complexity. Respawn garrisons fresh, respawn patrols fresh, reset the tactical situation. Only persist strategic state: which sectors are liberated, which objectives are complete, CP balance, FIA level, player loadout.

**"Moving units restart at starting positions" needs clarification.** Does this mean friendly patrols return to their spawn origins? If so, does the player notice a "reset" feel when loading? This is acceptable if the player only loads at TOC (everything distant resets unseen) but jarring if autosave triggers mid-field and the reload snaps everything back.

**Respawn at TOC in open play means traversal is never risky.** If death just means a teleport to TOC with no penalty, why would the player ever be cautious during exploration? Consider a soft penalty: lose carried (unequipped) loot, or unfinished HUMINT mission progress resets, or squad takes a readiness hit (slower to deploy again). Something that makes death sting without being punishing.

**Missing: what exactly is "important world state"?** Define the save data schema now:
- Liberated sectors (array of sector IDs)
- Operation states (completed, failed, available)
- CP balance
- FIA level and unit pool
- Player loadout and position (always TOC on load)
- HUMINT mission states
- Secondary objective states
- Collection progress (bunkers, caches, hostages)
- PMC intel progress
- Upgrade states (what has been purchased in each upgrade path)
- Global fail counter
- Counter-attack timer state

Write this list down. It becomes your save format specification.

---

## 11. Quests

### What You Have

**Operations:** Pre-placed, script-activated via strategic map. 3 failures = mission over. Pre-scripted events around player's role. Optimized for friendly victory. Losses = timer runs out or mass AI casualties. On failure: respawn at TOC, restart operation.
Flow: Start → Map briefing → Staging area → Start objectives (timed) → Complete objectives → Fight with AI to win.

**Secondary Objectives:** Pre-placed, activated on contested sectors, optional, affects operation difficulty. Incomplete objectives cancelled and data deleted.

**HUMINT:** Increases FIA pool, non-combat, available after liberation, unavailable if sector lost, pre-placed.

**PMC:** Reveals secret missions, pre-placed, restricted/heavily defended, find intel. All intel reveals secret mission. Must complete before Level 4. Rewards: PMC support vehicles, PMC base, PMC equipment.

**FIA Support Ops:** Pre-placed, earn CP, guerrilla missions, available after liberation, behind enemy lines, in contested sectors.

### Feedback

**The operation flow is well-defined.** Briefing → staging → timed objectives → combat resolution is a solid mission structure that gives each operation a clear beginning, middle, and end. The timer creates urgency, and "optimized for friendly victory" means the AI support is designed to win — the player's job is to enable that, not solo the entire thing. Good.

**"Two mission approaches per operation" (from your UI board) is ambitious and excellent.** Giving the player a choice between, say, a direct assault and a flanking/stealth approach per operation dramatically increases replay value and player agency. Build 2-3 operations with dual approaches first to validate the system before committing to all 16.

**"Must complete PMC before Level 4" is a hard gate that needs signposting.** If the player reaches Level 4 without finding all PMC intel, is the content locked forever? That's frustrating if the player didn't know the deadline existed. Either telegraph this heavily ("radio message: 'We're running out of time to investigate the PMC before the main push'") or make it a soft gate (PMC missions become harder but not impossible after Level 4).

**Secondary objective data being deleted on sector completion is correct.** You don't want stale objectives cluttering the quest log. But make sure the player knows they're time-limited — "these objectives are only available while the sector is contested" should be communicated clearly in the UI.

**HUMINT becoming unavailable when a sector is lost** creates a real consequence for counter-attacks. Good. The player doesn't just lose a sector — they lose access to FIA pool growth. This makes defending sectors matter beyond pride.

**Missing: FIA Support Ops mission variety.** You list cache stash, counter logistics, steal equipment, increase influence. Define what "increase influence" means mechanically — does it reduce counter-attack probability? Speed up FIA respawns? This is vague compared to the others.

---

## 12. UI & HUD

### What You Have

- **Squad Menu:** Spawn/despawn, manage loadout, refit squad (TOC only)
- **FIA Upgrades:** Assign points to spec tree (TOC only)
- **Action Menu:** Manage squad, misc commands, vehicle/supply/CAS/arty/mortar calls, accessible in field
- **Strategic Map:** View/start operations (TOC only)
- **Notifications:** Important events shown mid-game, saved to diary changelog
- **Campaign Overview:** View progress and stats
- **FIA Overview:** View FIA popularity, level, locations
- **Operation Mission Selector:** Two mission approaches per operation, player chooses

### Feedback

**The TOC-gated menus are correct.** Squad management, upgrades, and operation selection at TOC reinforces the base as a meaningful location. The action menu being field-accessible makes sense — you need to call support during combat.

**The action menu has 8 items.** That's a lot for Arma's interaction system. If you're using `addAction`, the scroll menu gets cluttered fast. Consider a custom radial menu or hierarchical action menu: one "Support" action that opens a sub-menu with CAS/arty/mortar/vehicle/supply. One "Squad" action for squad commands. This keeps the scroll menu clean.

**"Two mission approaches per operation" in the Operation Mission Selector is your most interesting UI moment.** This is where the player makes their tactical choice. Make it visually compelling — show the two approaches on the map with different insertion points, expected resistance, and time estimates. This screen sells the feeling of being a commander.

**Notifications saved to diary is smart.** It means the player can catch up on missed events. But throttle notifications during combat — you don't want "FIA POOL INCREASED" popping up while the player is in a firefight. Queue non-critical notifications and deliver them during downtime.

**Missing: a field map overlay.** The strategic map is TOC-only, but the player needs spatial information in the field. Custom map markers showing: current sector status, nearby objectives, FIA positions, known enemy positions. This is separate from the strategic map — it's the tactical picture available via the regular map screen.

**Missing: support asset cooldowns/availability display.** If the player has CAS, arty, mortar available, they need to see cooldown timers and ammo counts. A small HUD element or a check in the action menu ("CAS — READY" vs "CAS — 4:32 remaining").

---

## Cross-Domain Issues

### The AI Budget Problem

You have: sector garrisons, patrols, FIA defenders, player squad, ambient military activity, ambient battles, ambient civilians, counter-attack forces. On Altis (full map). At 6x time speed meaning more encounters per real hour.

This will not run well without aggressive spawn management. Define your hard AI cap now. Suggest: 60 AI total active at any time on mid-range hardware, 80-100 on high-end. Build the spawn manager to enforce this ceiling from day one. When the player approaches a sector, spawn the garrison. When they leave, despawn it. Ambient life only spawns within 500m. Ambient battles are sound effects only, not actual AI fighting.

### The Content Volume Problem

16 operations with dual approaches = 32 operation variants to build. 5+ HUMINT mission types across multiple sectors. 4+ FIA Support Op types. Secondary objectives per level. PMC intel chain. Collection objectives. This is a massive content authoring burden for a single developer (or small team). 

Recommendation: build the systems and pipeline first, then create content. Make it easy to add a new operation, a new HUMINT type, a new secondary objective. Data-driven design — operations defined in config arrays, not hard-coded scripts. If adding a new mission means editing one data file, you'll produce content 10x faster than if each mission is a bespoke script.

### The Pacing Risk

Between operations, the player does HUMINT (non-combat), FIA Support Ops (guerrilla combat), and secondary objectives (pre-operation). That's a lot of between-operation content. The risk is the player feels like they're grinding side content to unlock the next operation. Make sure the player can always start the next operation even without completing side content — side content makes it easier (reduced difficulty, more CP, bigger FIA pool) but is never a hard gate.

---

## Priority Actions

1. **Define the save data schema** — every field, every type, every default value. This unblocks all other development.
2. **Set AI budget ceiling** and build spawn manager — this determines what's actually possible with everything else.
3. **Rebalance unit skills** — FIA lower, player squad lower, AAF slightly higher. Test in a simple combat scenario.
4. **Flesh out the AAF** — behavioral variety, command structure degradation, named antagonist.
5. **Define CP cost table** — total CP available vs total upgrade costs. This ratio defines the entire economy feel.
6. **Build one complete operation** with dual approaches end-to-end before building systems. Validate the core experience works.
7. **Define secondary objectives for all levels** — currently only Level 0 has any.
8. **Add 3-4 more PMC locations** — one location doesn't support the intel-gathering quest chain.