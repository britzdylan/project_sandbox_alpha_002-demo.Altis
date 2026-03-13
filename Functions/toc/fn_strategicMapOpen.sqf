// ----------------------------------------------------------

// [display, pos, missions, ORBATs, markers, images, weather, night, scale, simulation, label, missionName, missionIcon] call BIS_fnc_strategicMapOpen
// Parameters:
// display: Display - parent display. When empty, mission display is used.
// pos: Array format position - default view position in format [x, y, y] or [x, y]
// missions: Array - list of missions, each Array in format:
// 0: position - 2D or 3D position of mission
// 1: Code - Expression executed when user clicks on mission icon
// 2: String - Mission name
// 3: String - Short description
// 4: String - Name of mission's player
// 5: String - Path to overview image
// 6: Number - size multiplier for overview image
// 7: Array - parameters for on-click action. Can be accessed in code with _this # 9
// ORBATs: Array - list of ORBAT, each Array in format:
// 0: Array format position - 2D or 3D position
// 1: Config - preview CfgORBAT group
// 2: Config - topmost displayed CfgORBAT group
// 3: Array of Strings - list of allowed tags
// 4: String - name of mission's player
// 5: Number - maximum number of displayed tiers
// markers: Array of Strings - list of markers revealed in strategic map (will be hidden when map is closed)
// images: Array - list of custom images, each Array in format:
// 0: String - texture path
// 1: Array format Color (RGBA)
// 2: Array format position - image position
// 3: Number - image width in meters
// 4: Number - image height in meters
// 5: Number - image angle in degrees
// 6: String - text displayed next to the image
// 7: Boolean - true to show shadow
// weather: Number - overcast, from 0 - 1, where 1 means cloudy weather
// night: Boolean - true for night version of strategic map (darker with blue tone)
// scale: Number - default map scale coeficient (1 is automatic scale)
// simulation: Boolean] - (Optional, default false true to enable simulation while the map is opened
// label: String - (Optional, default "Select a mission") bottom bar action label text
// missionName: Boolean - (Optional, default true) true to show icon label as a mission name
// missionIcon: String - (Optional, default "\A3\Ui_f\data\Map\GroupIcons\badge_rotate_%1_gs.paa") path to mission icon texture
// %1 - Animation frame from 0-6 (optional)
// %2 - Index from 1-9 (optional)
// ----------------------------------------------------------

#include "..\..\scripts\constants.hpp"

params ["_tocEntry"];

private _strategicMapMissions = _tocEntry get OSF_TOC_STRATEGIC_MISSION;
private _strategicMapWeather = random 1;
private _strategicMapTime = selectRandom [true, false];
private _pos = _strategicMapMissions select 0 select 0;

[findDisplay 46, _pos, _strategicMapMissions, [], [], [], _strategicMapWeather, _strategicMapTime, 1] call BIS_fnc_strategicMapOpen;