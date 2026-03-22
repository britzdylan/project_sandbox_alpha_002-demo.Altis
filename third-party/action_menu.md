# Action Menu - Player Guide

A radial wheel interface for Arma 3 that provides quick access to hand signals and custom actions.

## Requirements

- **CBA (Community Base Addons)** - Required for settings and keybinds.

---

## Basic Controls

| Action | Default Key |
|--------|-------------|
| Open/Close Menu | `~` (Tilde) |
| Close Menu | `ESC` or Right-click |
| Select Item | Left-click or Number keys `1-0` |
| Go Back (in submenu) | Click center "Go Back" button |

### Movement While Menu Is Open

You can continue moving while the menu is displayed, the idea is that you can be patrolling and don't need to stop in order to access a hand signal, throwing off your formation and spacing. If you're in a panic and see an enemy while navigating the menu, you can easily RMB as if you were going to aim your gun to close the menu and get in the fight.

---

## Using the Menu

1. Press `~` to open the radial menu.
2. Hover over an item with your mouse, or press a number key (1-0).
3. Click to execute the action or hand signal.
4. If you selected a submenu, it will expand showing more options.
5. Use the center "Go Back" button to return to the previous menu.
6. Press `ESC`, `~`, or right-click to close the menu in a panic.

### Item Types

- **Actions** - Execute custom code (sounds, scripts, etc.).
- **Signals** - Play a hand signal animation and broadcast text to nearby players, filtered by the visibility setting.
- **Submenus** - Open a nested menu with more options.

---

## Hand Signals

Hand signals allow you to communicate with your squad visually. When you use a hand signal:

1. Your character plays an animation (visible to everyone nearby) assuming you defined an animation in the button's properties.
2. A text notification appears on screen for nearby players. Who sees it depends on the **Signal Visibility** setting — by default only your group members will receive the notification.
3. In "Group" mode, enemy players and other squads cannot see the notification text. This keeps things clean in PvP missions. You can also set it to "Side" (same faction) or "All" (everyone in range) depending on how your unit likes to play.
4. Each signal has a range (default: 10m), which is configurable in the CBA settings or in the button properties itself.

### Notification Appearance

When a group member signals, a notification slides in from the top-left of your screen showing:
- The **signal text** in the configured color (e.g., "ENEMY SPOTTED" in red).
- The **sender's name** in white below it.
- An **icon** to the left (if the signal has one and the CBA setting is enabled).

If multiple signals arrive in quick succession, notifications stack vertically. Each notification stays on screen for the configured duration (default: 5 seconds), then slides off to the right.

---

## CBA Settings

Access settings via: **Options > Addon Options > Action Menu**

### Appearance Settings

| Setting | Description | Default |
|---------|-------------|---------|
| Menu Scale | Size of menu and buttons | 1.0 |
| Button Opacity | Transparency of buttons | 0.9 |
| Button Color (Normal) | Unselected button color | Dark gray |
| Button Color (Selected) | Hovered button color | Orange |
| Icon Opacity | Transparency of menu icons | 1.0 |
| Title Text Color | Color of menu title | Golden |
| Show Number Indicators | Display 1-0 above buttons | Off |
| Circle Squash | Vertical compression of button circle (lower = flatter) | 0.9 |

### General Settings

| Setting | Description | Default |
|---------|-------------|---------|
| Standalone Mode | Controls the menu when no Eden module is placed in the mission. **Disabled** means the menu stays off. **Default Config** loads the built-in menu. **Custom Config** uses a config string you paste in below. If a mission has an Eden module placed, it always takes priority over this setting. | Disabled |
| Custom Config String | Paste a raw menu config string here (exported from the Visual Editor or copied from someone else's mission). This only applies when Standalone Mode is set to "Custom Config." | *(empty)* |

### Signal Settings

| Setting | Description | Default |
|---------|-------------|---------|
| Signal Visibility | Controls who receives signal text notifications. **Group** means only your squad. **Side** means anyone on your faction. **All** means everyone in range regardless of side. This is a server-controlled setting. | Group |
| Signal Display Duration | How long notifications show. | 5 seconds |
| Default Signal Radius | Broadcast range for signals (server-controlled). | 10m |
| Notification Size | Scale of signal notifications. | 1.0x |
| Notification Opacity | Background transparency. | 0.5 |
| Show Signal Icon | Display icons in notifications. | On |
| Notification Icon Opacity | Icon transparency. | 1.0 |

### Keybinds

All keybinds can be remapped in **Options > Controls > Configure Addons > Action Menu**

| Keybind | Description | Default |
|---------|-------------|---------|
| Toggle Action Menu | Open/close the menu | `~` |
| Select Button 1-10 | Quick-select menu items | `1-0` |

### Direct-Action Keybinds

Every action in the menu is also registered as an individual CBA keybind under **"Action Menu - Individual Buttons"**. This lets you trigger any action directly without opening the menu. We recommend this option for commonly used hand signals or for those with a stream deck.

All start unbound by default. They only fire when the menu is closed and you're not in a dialog.

---

## Multiplayer

- The menu configuration is set by the mission maker (or via Standalone Mode if no module is placed) and synced to all players.
- **Join In Progress (JIP)** is fully supported and multiplayer is synced properly.
- Hand signal text notifications are filtered by the **Signal Visibility** setting. In "Group" mode, only your own squad sees them, so multiple squads can operate independently without cluttering each other's screens.

---

## For Mission Makers
a3\3den\data\attributes\wedge_ca.paa
### Placing the Module

1. Open your mission in Eden Editor.
2. Find **Action Menu > Action Menu Configuration** in the modules list.
3. Place the module anywhere in your mission (position doesn't matter).
4. The module will automatically initialize for all players.

### Configuring the Menu

1. Double-click the module, or right-click > Edit Attributes
2. Click **"Open Visual Editor"** button.
3. Use the tree view to navigate and edit menu items:
   - **Add Item** - Create new action or signal
   - **Add Submenu** - Create nested menu
   - **Remove Item** - Delete selected item
   - **Move Up/Down** - Reorder items
4. Click **Save** when finished

### Menu Item Properties

| Property | Description |
|----------|-------------|
| Label | Display text shown on the button |
| Type | `action`, `signal`, or `submenu` |
| Code | SQF code to execute (for actions/signals) |
| Icon | Path to .paa icon file (optional) |

### Signal Code Format

```sqf
[player, "animation_class", "DISPLAY TEXT", radius, [R,G,B,A]] call GW_fnc_handSignal
```

- `animation_class` - Animation to play (or `"none"` for text only)
- `"DISPLAY TEXT"` - Text shown to nearby players (filtered by visibility setting).
- `radius` - Broadcast range in meters (0 uses CBA setting)
- `[R,G,B,A]` - Text color (optional, default white)

**Example:**
```sqf
[player, "vn_handsignal_freeze", "FREEZE", 50, [1,0,0,1]] call GW_fnc_handSignal
```

### Action Code Format

Any valid SQF code:

```sqf
// Play a sound
playSound3D ["\path\to\sound.ogg", player, false, getPosASL player, 3, 1, 50];

// Call a function
[] call MY_fnc_doSomething;

// Execute script
hint "Action executed!";
```

### Available Icons

The mod bundles the following icons in `\action_menu\data\`. Use these paths in the Icon field:

| Icon | Path |
|------|------|
| 1IC To Me | `\action_menu\data\1ic_to_me.paa` |
| Attack | `\action_menu\data\attack.paa` |
| Bail Out | `\action_menu\data\bail_out.paa` |
| Blast Through | `\action_menu\data\blast_through.paa` |
| Breach Wall | `\action_menu\data\breach_wall.paa` |
| Breacher Up | `\action_menu\data\breacher_up.paa` |
| Breacher Up (Alt) | `\action_menu\data\breacher_up_alt.paa` |
| Bump | `\action_menu\data\bump.paa` |
| CAS Inbound | `\action_menu\data\cas_inbound.paa` |
| Check Door | `\action_menu\data\check_door.paa` |
| Checkpoint | `\action_menu\data\checkpoint.paa` |
| Checkmark | `\action_menu\data\checkmark.paa` |
| Circle | `\action_menu\data\circle.paa` |
| Clicker | `\action_menu\data\clicker.paa` |
| Compass (N/NE/E/SE/S/SW/W/NW) | `\action_menu\data\compass_n.paa` (etc.) |
| Danger Area | `\action_menu\data\danger_area.paa` |
| Door Here | `\action_menu\data\door_here.paa` |
| Drink Water | `\action_menu\data\drink_water.paa` |
| Drink Water (Alt) | `\action_menu\data\drink_water_alt.paa` |
| Enemy Heard | `\action_menu\data\enemy_heard.paa` |
| Enemy Spotted | `\action_menu\data\enemy_spotted.paa` |
| File | `\action_menu\data\file.paa` |
| Fire | `\action_menu\data\fire.paa` |
| Flashbang Out | `\action_menu\data\flashbang_out.paa` |
| Frag Out | `\action_menu\data\frag_out.paa` |
| Freeze / Danger | `\action_menu\data\freeze_danger.paa` |
| Gate | `\action_menu\data\gate.paa` |
| Get Down | `\action_menu\data\get_down.paa` |
| Go Around | `\action_menu\data\go_around.paa` |
| Halt | `\action_menu\data\halt.paa` |
| Hurry | `\action_menu\data\hurry.paa` |
| Kick Door | `\action_menu\data\kick_door.paa` |
| Lag Pointman | `\action_menu\data\lag_pointman.paa` |
| Laydog | `\action_menu\data\laydog.paa` |
| Line | `\action_menu\data\line.paa` |
| Lizard Squeak | `\action_menu\data\lizard_squeak.paa` |
| Lockpick Door | `\action_menu\data\lockpick_door.paa` |
| Magazine Tap | `\action_menu\data\magazine_tap.paa` |
| Mine Rear | `\action_menu\data\mine_rear.paa` |
| Mine Rear (Alt) | `\action_menu\data\mine_rear_alt.paa` |
| Minefield | `\action_menu\data\minefield.paa` |
| Minus | `\action_menu\data\minus.paa` |
| Move Out | `\action_menu\data\move_out.paa` |
| Objective Spotted | `\action_menu\data\obj_spotted.paa` |
| Octagon | `\action_menu\data\octagon.paa` |
| Padlock (Locked) | `\action_menu\data\padlock_locked.paa` |
| Padlock (Unlocked) | `\action_menu\data\padlock_unlocked.paa` |
| Plus | `\action_menu\data\plus.paa` |
| Question | `\action_menu\data\question.paa` |
| Regroup | `\action_menu\data\regroup.paa` |
| Space Out | `\action_menu\data\space_out.paa` |
| Square | `\action_menu\data\square.paa` |
| Stack Up | `\action_menu\data\stack_up.paa` |
| Stop | `\action_menu\data\stop.paa` |
| Take Photo | `\action_menu\data\take_photo.paa` |
| Thumbs Down | `\action_menu\data\thumbs_down.paa` |
| Thumbs Up | `\action_menu\data\thumbs_up.paa` |
| Tongue Click | `\action_menu\data\tongue_click.paa` |
| Trap | `\action_menu\data\trap.paa` |
| Triangle | `\action_menu\data\triangle.paa` |
| Twig | `\action_menu\data\twig.paa` |
| Twig (Alt) | `\action_menu\data\twig_alt.paa` |
| Wedge | `\action_menu\data\wedge.paa` |
| Wheel (mod icon) | `\action_menu\data\wheel.paa` |
| Whistle 1 | `\action_menu\data\whistle_1.paa` |
| Whistle 2 | `\action_menu\data\whistle_2.paa` |

You can also use any Arma 3 built-in texture path (e.g., `a3\3den\data\attributes\stance\up_ca.paa`).

### Import/Export Configurations

Menu configurations can be copied between missions:

1. Right-click the module > Edit Attributes
2. Copy the text from **"Menu Configuration (Raw)"**
3. Paste into another mission's module to import

---

## Default Menu Structure

This is the fallback configuration used when a mission maker places the Eden module but leaves the Visual Editor empty. Only the URGENT submenu is fully functional — the other three contain blank placeholders. Notice how the existing hand signals have vn_ (SOG Prairie Fire) animations. If you do not have the DLC enabled, you simply won't play a hand signal and will require to use Vanilla animations.

## URGENT (submenu)

| Label | Type | Animation | Signal Text | Range | Color | Icon |
|-------|------|-----------|-------------|-------|-------|------|
| Enemy Spotted | signal | `vn_handsignal_spotted` | ENEMY SPOTTED | 50m | Red `[1,0,0,1]` | `enemy_spotted.paa` |
| Enemy Heard | signal | `vn_handsignal_spotted` | ENEMY HEARD | 50m | Red `[1,0,0,1]` | `enemy_heard.paa` |
| Trap | signal | `vn_handsignal_trap` | TRAP | CBA default | White | `trap.paa` |
| Get Down | signal | `vn_handsignal_down` | GET DOWN | CBA default | White | `get_down.paa` |
| Move Out | signal | `vn_handsignal_move_out` | MOVE OUT | CBA default | White | `move_out.paa` |
| CAS Inbound | signal | `vn_handsignal_observe` | CAS INBOUND | CBA default | White | `cas_inbound.paa` |
| Halt | signal | `vn_handsignal_freeze` | HALT | CBA default | White | `halt.paa` |
| Freeze | signal | `vn_handsignal_freeze` | FREEZE | CBA default | White | `freeze_danger.paa` |

## SIGNALS (submenu)

| Label | Type | Code | Icon |
|-------|------|------|------|
| A | signal | *(empty)* | — |
| B | signal | *(empty)* | — |
| C | signal | *(empty)* | — |

## MISC. (submenu)

| Label | Type | Code | Icon |
|-------|------|------|------|
| A | action | *(empty)* | — |
| B | action | *(empty)* | — |
| C | action | *(empty)* | — |

## ACTIONS (submenu)

| Label | Type | Code | Icon |
|-------|------|------|------|
| A | action | *(empty)* | — |
| B | action | *(empty)* | — |
| C | action | *(empty)* | — |

## Recommended Menu Structure

***If you are a recon style unit and are using the Commonwealth Hand Signals, Hey You, and TSP Animate mod along with the SOG DLC, below is the recommended raw configuration you can paste in and give a shot. NOTE: Some of the icons are not fully setup, will bugfix next update.***

```sqf
[["URGENT","submenu",[["Enemy Spotted","signal","[player, 'cam_enemy', 'ENEMY SPOTTED', 50, [1,0,0,1]] call GW_fnc_handSignal   
","\action_menu\data\enemy_spotted.paa"],["Enemy Heard","signal","[player, 'cam_ForF', 'ENEMY HEARD', 50, [1,0,0,1]] call GW_fnc_handSignal   
","\action_menu\data\enemy_heard.paa"],["Trap","signal","[player, 'vn_handsignal_trap', 'TRAP', 0] call GW_fnc_handSignal","\action_menu\data\trap.paa"],["Get Down","signal","[player, 'vn_handsignal_down', 'GET DOWN', 0] call GW_fnc_handSignal","\action_menu\data\get_down.paa"],["Move Out","signal","[player, 'vn_handsignal_move_out', 'MOVE OUT', 0] call GW_fnc_handSignal","\action_menu\data\move_out.paa"],["CAS Inbound","signal","[player, 'vn_handsignal_observe', 'CAS INBOUND', 0] call GW_fnc_handSignal","\action_menu\data\cas_inbound.paa"],["Halt","signal","[player, 'tsp_animate_halt', 'HALT', 0] call GW_fnc_handSignal","\action_menu\data\halt.paa"],["Freeze","signal","[player, 'vn_handsignal_freeze', 'FREEZE', 0] call GW_fnc_handSignal","\action_menu\data\freeze_danger.paa"],["Linear Danger","signal","[player, 'vn_handsignal_observe', 'LINEAR DANGER AREA', 0] call GW_fnc_handSignal","\action_menu\data\danger_area.paa"],["OBJ Spotted","signal","[player, 'cam_enemy', 'ENEMY SPOTTED', 50, [1,0,0,1]] call GW_fnc_handSignal   
","\action_menu\data\obj_spotted.paa"]]],["SIGNALS","submenu",[["Laydog","signal","[player, 'vn_handsignal_double', 'LAYDOG', 0] call GW_fnc_handSignal","\action_menu\data\laydog.paa"],["Door Here","signal","[player, 'vn_handsignal_regroup', 'DOOR HERE', 0] call GW_fnc_handSignal","\action_menu\data\door_here.paa"],["Regroup","signal","[player, 'vn_handsignal_regroup', 'REGROUP', 0] call GW_fnc_handSignal","\action_menu\data\regroup.paa"],["FORMATIONS","submenu",[["File","signal","[player, 'vn_handsignal_column', 'FILE', 0] call GW_fnc_handSignal","\action_menu\data\file.paa"],["Line","signal","[player, 'vn_handsignal_line', 'LINE', 0] call GW_fnc_handSignal","\action_menu\data\line.paa"],["Wedge","signal","[player, 'vn_handsignal_move_left', 'WEDGE', 0] call GW_fnc_handSignal","\action_menu\data\wedge.paa"],["Lag Pointman","signal","[player, 'vn_handsignal_move_right', 'LAG POINTMAN', 0] call GW_fnc_handSignal","\action_menu\data\lag_pointman.paa"],["Space Out","signal","[player, 'vn_handsignal_move_right', 'SPACE OUT', 0] call GW_fnc_handSignal","\action_menu\data\space_out.paa"]]],["DIRECTIONS","submenu",[["N","signal","[player, 'none', 'NORTH', 0] call GW_fnc_handSignal","\action_menu\data\compass_n.paa"],["NE","signal","[player, 'none', 'NORTHEAST', 0] call GW_fnc_handSignal","\action_menu\data\compass_ne.paa"],["E","signal","[player, 'none', 'EAST', 0] call GW_fnc_handSignal","\action_menu\data\compass_e.paa"],["SE","signal","[player, 'none', 'SOUTHEAST', 0] call GW_fnc_handSignal","\action_menu\data\compass_se.paa"],["S","signal","[player, 'none', 'SOUTH', 0] call GW_fnc_handSignal","\action_menu\data\compass_s.paa"],["SW","signal","[player, 'none', 'SOUTHWEST', 0] call GW_fnc_handSignal","\action_menu\data\compass_sw.paa"],["W","signal","[player, 'none', 'WEST', 0] call GW_fnc_handSignal","\action_menu\data\compass_w.paa"],["NW","signal","[player, 'none', 'NORTHWEST', 0] call GW_fnc_handSignal","\action_menu\data\compass_nw.paa"]]],["DANGER AREAS","submenu",[["ODA","signal","[player, 'vn_handsignal_observe', 'ODA', 0] call GW_fnc_handSignal","\action_menu\data\danger_area.paa"],["LDA","signal","[player, 'vn_handsignal_observe', 'LDA', 0] call GW_fnc_handSignal","\action_menu\data\danger_area.paa"],["Blast Through","signal","[player, 'vn_handsignal_attack', 'BLAST THROUGH', 0] call GW_fnc_handSignal","\action_menu\data\blast_through.paa"],["Gate","signal","[player, 'tsp_animate_clacker', 'GATE', 0] call GW_fnc_handSignal","\action_menu\data\gate.paa"],["Bump","signal","[player, 'tsp_animate_frag', 'BUMP', 0] call GW_fnc_handSignal","\action_menu\data\bump.paa"],["Go Around","signal","[player, 'HandSignalMoveOut', 'GO AROUND', 0] call GW_fnc_handSignal","\action_menu\data\go_around.paa"],["Go Through","signal","[player, 'HandSignalMoveForward', 'GO THROUGH', 0] call GW_fnc_handSignal","\action_menu\data\attack.paa"]]],["STANCES","submenu",[["Combat Pace","signal","","a3\3den\data\attributes\speedmode\normal_ca.paa"],["Walk","signal","","a3\3den\data\attributes\stance\up_ca.paa"],["Crouch","signal","","a3\3den\data\attributes\stance\middle_ca.paa"],["Prone","signal","","a3\3den\data\attributes\stance\down_ca.paa"]]],["NUMBERS","submenu",[["1","signal","[player, 'none', '1', 0] call GW_fnc_handSignal"],["2","signal","[player, 'none', '2', 0] call GW_fnc_handSignal"],["3","signal","[player, 'none', '3', 0] call GW_fnc_handSignal"],["4","signal","[player, 'none', '4', 0] call GW_fnc_handSignal"],["5","signal","[player, 'none', '5', 0] call GW_fnc_handSignal"],["6","signal","[player, 'none', '6', 0] call GW_fnc_handSignal"],["7","signal","[player, 'none', '7', 0] call GW_fnc_handSignal"],["8","signal","[player, 'none', '8', 0] call GW_fnc_handSignal"],["9","signal","[player, 'none', '9', 0] call GW_fnc_handSignal"],["0","signal","[player, 'none', '0', 0] call GW_fnc_handSignal"]]],["1IC To Me","signal","[player, 'tsp_animate_ok_in', '1IC TO ME', 0] call GW_fnc_handSignal","\action_menu\data\1ic_to_me.paa"],["Mine Rear","signal","[player, 'tsp_animate_ok_in', 'MINE REAR', 0] call GW_fnc_handSignal","\action_menu\data\mine_rear.paa"]]],["MISC.","submenu",[["CHECKPOINT","submenu",[["CP 1","signal","[player, 'HandSignalMoveForward', 'CP 1', 0] call GW_fnc_handSignal","\action_menu\data\checkpoint.paa"],["CP 2","signal","[player, 'HandSignalMoveForward', 'CP 2', 0] call GW_fnc_handSignal","\action_menu\data\checkpoint.paa"],["CP 3","signal","[player, 'HandSignalMoveForward', 'CP 3', 0] call GW_fnc_handSignal","\action_menu\data\checkpoint.paa"],["CP 4","signal","[player, 'HandSignalMoveForward', 'CP 4', 0] call GW_fnc_handSignal","\action_menu\data\checkpoint.paa"],["CP 5","signal","[player, 'HandSignalMoveForward', 'CP 5', 0] call GW_fnc_handSignal","\action_menu\data\checkpoint.paa"],["CP 6","signal","[player, 'HandSignalMoveForward', 'CP 6', 0] call GW_fnc_handSignal","\action_menu\data\checkpoint.paa"],["CP 7","signal","[player, 'HandSignalMoveForward', 'CP 7', 0] call GW_fnc_handSignal","\action_menu\data\checkpoint.paa"],["CP 8","signal","[player, 'HandSignalMoveForward', 'CP 8', 0] call GW_fnc_handSignal","\action_menu\data\checkpoint.paa"]]],["Drink Water","signal","[player, 'tsp_animate_ok_in', 'DRINK WATER', 0] call GW_fnc_handSignal","\action_menu\data\drink_water.paa"],["Take Photo","signal","[player, 'vn_handsignal_observe', 'TAKE PHOTO', 0] call GW_fnc_handSignal","\action_menu\data\take_photo.paa"]]],["SOUNDS","submenu",[["LONG WHISTLE","","""whistle_1"" call cam_fnc_sound;","\action_menu\data\whistle_2.paa"],["SHORT WHISTLE","action","""whistle_2"" call cam_fnc_sound;","\action_menu\data\whistle_1.paa"],["CLICK","","""tongue_click"" call cam_fnc_sound;","\action_menu\data\clicker.paa"],["MAG TAP","","""magazine_tap"" call cam_fnc_sound;","\action_menu\data\magazine_tap.paa"],["TONGUE CLICK","action","playSound3D [""\hey_you\sounds\TongueClick2x.ogg"", player, false, getPosASL player, 3, 1, 50];","\action_menu\data\tongue_click.paa"],["LIZARD SQUEAK","action","playSound3D [""\hey_you\sounds\Lizard_Squeak.ogg"", player, false, getPosASL player, 3, 1, 50];","\action_menu\data\lizard_squeak.paa"],["TWIG CRACK","action","playSound3D [""\hey_you\sounds\Twig_Crack.ogg"", player, false, getPosASL player, 3, 1, 50];","\action_menu\data\twig_alt.paa"]]]]
```

---

## Development Reference

This section is for mission makers and scripters who want to build custom menu configurations using the Visual Editor or raw config editing.

### GW_fnc_handSignal — Full Parameter Reference

```sqf
[unit, animation, displayText, radius, textColor, iconPath] call GW_fnc_handSignal
```

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `unit` | Object | Yes | The unit performing the signal (usually `player`) |
| `animation` | String | Yes | Animation classname to play, or `"none"` for text-only |
| `displayText` | String | Yes | Text shown to nearby players, filtered by the visibility setting (uppercase recommended). |
| `radius` | Number | No | Broadcast range in meters. `0` = use CBA setting (default 10m) |
| `textColor` | Array | No | `[R,G,B,A]` color for the notification text. Default: `[1,1,1,1]` (white) |
| `iconPath` | String | No | Path to a `.paa` icon. If omitted, auto-looked up from the menu config |

### Hand Signal Examples

**Basic signal (white text, CBA default range):**
```sqf
[player, "vn_handsignal_freeze", "FREEZE"] call GW_fnc_handSignal
```

**Red warning signal with 50m range:**
```sqf
[player, "vn_handsignal_spotted", "ENEMY SPOTTED", 50, [1,0,0,1]] call GW_fnc_handSignal
```

**Text-only signal (no animation):**
```sqf
[player, "none", "HOLD POSITION", 0, [1,0.8,0,1]] call GW_fnc_handSignal
```

**Signal with explicit icon:**
```sqf
[player, "vn_handsignal_freeze", "HALT", 50, [1,1,1,1], "\action_menu\data\halt.paa"] call GW_fnc_handSignal
```

### Animation Classnames

The animation parameter accepts any valid Arma 3 animation class. Common sources:

# Animation Reference

| Vanilla | ACE | TSP | SOG | Commonwealth |
|---|---|---|---|---|
| GestureAdvance | ace_common_stop | tsp_animate_abort | vn_handsignal_attack | cam_enemy |
| GestureAdvanceProne | ace_gestures_Base | tsp_animate_bang | vn_handsignal_column | cam_ForF |
| GestureAttackStand | ace_gestures_cover | tsp_animate_bird_in | vn_handsignal_cover | cam_ok |
| GestureCeaseFire | ace_gestures_coverStandLowered | tsp_animate_bird_loop | vn_handsignal_double | |
| GestureChangeAntenna | ace_gestures_engage | tsp_animate_breach | vn_handsignal_down | |
| GestureCover | ace_gestures_engageStandLowered | tsp_animate_captive | vn_handsignal_freeze | |
| GestureFollow | ace_gestures_forward | tsp_animate_chemlight_wnon_lnon | vn_handsignal_line | |
| GestureFreezeStand | ace_gestures_forwardStandLowered | tsp_animate_chemlight_wpst_lhig | vn_handsignal_move_left | |
| GestureGoBProne | ace_gestures_freeze | tsp_animate_clacker | vn_handsignal_move_out | |
| GestureGoBStand | ace_gestures_freezeStandLowered | tsp_animate_column | vn_handsignal_move_right | |
| GestureGoStand | ace_gestures_hold | tsp_animate_compass_in | vn_handsignal_no | |
| GestureGoStandPistol | ace_gestures_holdStandLowered | tsp_animate_compass_loop | vn_handsignal_observe | |
| GestureHi | ace_gestures_point | tsp_animate_dab_loop | vn_handsignal_ok | |
| GestureHiB | ace_gestures_pointStandLowered | tsp_animate_frag | vn_handsignal_regroup | |
| GestureHiC | ace_gestures_regroup | tsp_animate_halt | vn_handsignal_spotted | |
| GestureLegPush | ace_gestures_regroupStandLowered | tsp_animate_heart_loop | vn_handsignal_trap | |
| GestureNo | ace_gestures_warning | tsp_animate_horns_loop | | |
| GestureNod | ace_gestures_warningStandLowered | tsp_animate_knock | | |
| GesturePointStand | | tsp_animate_ladder | | |
| GestureUp | | tsp_animate_lift | | |
| GestureWipeFace | | tsp_animate_line | | |
| GestureYes | | tsp_animate_ok_in | | |
| HandSignalFreeze | | tsp_animate_peek | | |
| HandSignalGetDown | | tsp_animate_ready | | |
| HandSignalGetUp | | tsp_animate_shotgun | | |
| HandSignalHold | | tsp_animate_sling_check | | |
| HandSignalMoveForward | | tsp_animate_wedge | | |
| HandSignalMoveOut | | tsp_common_stop | | |
| HandSignalPoint | | tsp_common_stop_instant | | |
| HandSignalRadio | | tsp_common_stop_left | | |
| | | tsp_common_stop_right | | |

**No animation:**

Use `"none"` to send a text-only notification without playing any animation.

### Action Code Examples

Actions execute arbitrary SQF code when selected. Here are common patterns:

**Play a 3D sound:**
```sqf
playSound3D ["\path\to\sound.ogg", player, false, getPosASL player, 3, 1, 50]
```
Parameters: path, source, isInside, position, volume, pitch, maxDistance

**Display a hint:**
```sqf
hint "Checkpoint marked!"
```

**Set a marker on the map:**
```sqf
private _mkr = createMarkerLocal ["myMarker", getPos player];
_mkr setMarkerTypeLocal "mil_dot";
_mkr setMarkerTextLocal "HERE";
```

**Call a custom function:**
```sqf
[] call MY_fnc_doSomething
```

**Change player stance:**
```sqf
player playAction "PlayerProne"
```

**Toggle flashlight:**
```sqf
player action ["GunLightOn", player]
```

### Color Reference

Colors are `[R, G, B, A]` arrays where each value is `0.0` to `1.0`.

| Color | Value |
|-------|-------|
| White | `[1, 1, 1, 1]` |
| Red | `[1, 0, 0, 1]` |
| Green | `[0, 1, 0, 1]` |
| Blue | `[0, 0, 1, 1]` |
| Yellow | `[1, 1, 0, 1]` |
| Orange | `[1, 0.5, 0, 1]` |
| Cyan | `[0, 1, 1, 1]` |
| 50% transparent white | `[1, 1, 1, 0.5]` |

### Raw Configuration Format

The menu config is a nested SQF array. Each item is `[label, type, codeOrChildren, iconPath]`:

```sqf
[
    ["URGENT", "submenu", [
        ["Enemy Spotted", "signal",
            "[player, 'vn_handsignal_spotted', 'ENEMY SPOTTED', 50, [1,0,0,1]] call GW_fnc_handSignal",
            "\action_menu\data\enemy_spotted.paa"],
        ["Halt", "signal",
            "[player, 'vn_handsignal_freeze', 'HALT', 0] call GW_fnc_handSignal",
            "\action_menu\data\halt.paa"]
    ]],
    ["Drink Water", "action",
        "hint 'Drinking water...'",
        "\action_menu\data\drink_water.paa"],
    ["SOUNDS", "submenu", [
        ["Long Whistle", "action",
            "playSound3D ['\\path\\to\\whistle.ogg', player, false, getPosASL player, 3, 1, 50]",
            "\action_menu\data\whistle_1.paa"]
    ]]
]
```

**Item types:**
- `"signal"` — Code field must call `GW_fnc_handSignal`
- `"action"` — Code field can be any SQF
- `"submenu"` — Third element is a nested array of child items (not a code string)

**Nesting limit:** Submenus support up to 3 levels deep.

**Escaping:** When editing raw config, single quotes inside code strings avoid escaping issues. If you must use double quotes, escape them: `""`.

### Tips for the Visual Editor

- **Test incrementally** — Add one item, save, and test in preview before building a full menu.
- **Keep labels short** — Long labels overlap on the radial wheel. Aim for 1-3 words.
- **Use submenus for organization** — Group related actions to avoid crowding the top level (max 10 items per level).
- **Icon paths must be exact** — Copy paths from the Available Icons table above; typos produce invisible icons.
- **Arma built-in textures work** — You can use any texture from the game (e.g., `a3\3den\data\attributes\stance\up_ca.paa`).

---

## Troubleshooting

### Menu Won't Open

- Make sure the mission has an Action Menu module placed, **or** enable Standalone Mode in your CBA settings (Options > Addon Options > Action Menu > General).
- Check that CBA is installed and enabled.
- Verify the keybind in addon controls settings.
- The menu will not open while any of these are active: **map**, **inventory**, **any dialog/UI**, or **ACE interaction menu**. Close them first.

### Signals Not Visible to Teammates

- Check the **Signal Visibility** setting. In "Group" mode, you need to be in the same squad. If you're running mixed groups, try switching it to "Side" or "All."
- Check the signal radius setting (may be too small).
- Ensure signal/notification settings aren't set to 0 opacity.

### Number Keys Don't Work

- Check that keybinds aren't remapped or conflicting.

### Icons Not Displaying

- Verify the icon path is correct (must start with `\action_menu\data\`) if you're using the mod's icons.
- Only icons listed in the "Available Icons" table are bundled with the mod.
- Check RPT log for "Picture not found" errors.


### ACRE2 Keybind Conflict

If you use ACRE2, its "Talk through Zeus" (ZeusTalkFromCamera) defaults to tilde (`~`), which conflicts with the Action Menu toggle. This can cause radio PTT to drop when the menu closes. The mod detects this at startup and warns via systemChat. Fix: rebind one of them in **Options > Controls > Configure Addons**.

---

## Credits

**Author:** Dexter

**Dependencies:** CBA (Community Base Addons)
