// ============================================================
// OSF_fnc_notify
// Custom notification system — replaces all hint/hintSilent usage.
// Displays a styled notification bar in the top-right corner with
// type-based color coding and sound.
//
// Types:
//   "info"    — white text, subtle chime (default)
//   "success" — green text, positive chime
//   "warning" — amber text, warning tone
//   "error"   — red text, alert tone
//   "tip"     — grey text, no sound (tutorial hints)
//
// Params:
//   _text     (STRING)  — notification message
//   _type     (STRING, optional — default "info")
//   _duration (NUMBER, optional — default 5) — seconds to show
//
// Returns: nothing (spawned — non-blocking)
// Usage:
//   ["Game saved.", "success"] call OSF_fnc_notify;
//   ["Invalid vehicle type.", "error"] call OSF_fnc_notify;
//   ["Use WASD to move. Hold SHIFT to sprint.", "tip", 8] call OSF_fnc_notify;
// ============================================================

params ["_text", ["_type", "info"], ["_duration", 5]];

// ---- Type → color + sound ----
private _color = switch (toLower _type) do {
    case "success": { [0.62, 0.80, 0.42, 1.0] };  // green
    case "warning": { [0.95, 0.78, 0.30, 1.0] };   // amber
    case "error":   { [0.88, 0.22, 0.22, 1.0] };    // red
    case "tip":     { [0.70, 0.72, 0.68, 0.9] };    // grey
    default         { [0.85, 0.88, 0.82, 1.0] };    // white (info)
};

private _labelColor = switch (toLower _type) do {
    case "success": { [0.62, 0.80, 0.42, 0.6] };
    case "warning": { [0.95, 0.78, 0.30, 0.6] };
    case "error":   { [0.88, 0.22, 0.22, 0.6] };
    case "tip":     { [0.70, 0.72, 0.68, 0.4] };
    default         { [0.85, 0.88, 0.82, 0.4] };
};

private _label = switch (toLower _type) do {
    case "success": { "COMPLETE" };
    case "warning": { "WARNING" };
    case "error":   { "ERROR" };
    case "tip":     { "TIP" };
    default         { "INTEL" };
};

private _sound = switch (toLower _type) do {
    case "success": { "incoming" };
    case "warning": { "incoming" };
    case "error":   { "incoming" };
    case "tip":     { "incoming" };
    default         { "incoming" };
};

// ---- Spawn the notification (non-blocking) ----
[_text, _color, _labelColor, _label, _sound, _duration] spawn {
    params ["_text", "_color", "_labelColor", "_label", "_sound", "_duration"];

    disableSerialization;

    // Play sound
    if (_sound != "") then {
        playSound _sound;
    };

    // Get in-game display
    private _display = findDisplay 46;
    if (isNull _display) exitWith {};

    // ---- Background bar ----
    private _ctrlBG = _display ctrlCreate ["RscText", -1];
    _ctrlBG ctrlSetPosition [
        safeZoneX + safeZoneW * 0.60,   // right-aligned
        safeZoneY + safeZoneH * 0.02,    // near top
        safeZoneW * 0.39,
        safeZoneH * 0.06
    ];
    _ctrlBG ctrlSetBackgroundColor [0.02, 0.03, 0.02, 0.85];
    _ctrlBG ctrlCommit 0;

    // ---- Accent stripe (left edge) ----
    private _ctrlAccent = _display ctrlCreate ["RscText", -1];
    _ctrlAccent ctrlSetPosition [
        safeZoneX + safeZoneW * 0.60,
        safeZoneY + safeZoneH * 0.02,
        safeZoneW * 0.003,
        safeZoneH * 0.06
    ];
    _ctrlAccent ctrlSetBackgroundColor _color;
    _ctrlAccent ctrlCommit 0;

    // ---- Type label ----
    private _ctrlLabel = _display ctrlCreate ["RscStructuredText", -1];
    _ctrlLabel ctrlSetPosition [
        safeZoneX + safeZoneW * 0.612,
        safeZoneY + safeZoneH * 0.022,
        safeZoneW * 0.37,
        safeZoneH * 0.018
    ];
    private _labelHex = format ["#%1%2%3",
        ([round ((_labelColor select 0) * 255)] call {
            params ["_v"];
            private _h = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
            (_h select (floor (_v / 16))) + (_h select (_v mod 16))
        }),
        ([round ((_labelColor select 1) * 255)] call {
            params ["_v"];
            private _h = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
            (_h select (floor (_v / 16))) + (_h select (_v mod 16))
        }),
        ([round ((_labelColor select 2) * 255)] call {
            params ["_v"];
            private _h = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
            (_h select (floor (_v / 16))) + (_h select (_v mod 16))
        })
    ];
    _ctrlLabel ctrlSetStructuredText parseText format [
        "<t font='PuristaBold' size='0.7' color='%1'>%2</t>",
        _labelHex, _label
    ];
    _ctrlLabel ctrlCommit 0;

    // ---- Message text ----
    private _ctrlText = _display ctrlCreate ["RscStructuredText", -1];
    _ctrlText ctrlSetPosition [
        safeZoneX + safeZoneW * 0.612,
        safeZoneY + safeZoneH * 0.038,
        safeZoneW * 0.37,
        safeZoneH * 0.038
    ];
    // Convert \n to <br/>
    private _formatted = _text;
    _formatted = _formatted splitString "\n" joinString "<br/>";

    private _colorHex = format ["#%1%2%3",
        ([round ((_color select 0) * 255)] call {
            params ["_v"];
            private _h = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
            (_h select (floor (_v / 16))) + (_h select (_v mod 16))
        }),
        ([round ((_color select 1) * 255)] call {
            params ["_v"];
            private _h = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
            (_h select (floor (_v / 16))) + (_h select (_v mod 16))
        }),
        ([round ((_color select 2) * 255)] call {
            params ["_v"];
            private _h = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
            (_h select (floor (_v / 16))) + (_h select (_v mod 16))
        })
    ];
    _ctrlText ctrlSetStructuredText parseText format [
        "<t font='PuristaLight' size='0.9' color='%1'>%2</t>",
        _colorHex, _formatted
    ];
    _ctrlText ctrlCommit 0;

    // ---- Slide-in animation ----
    // Start off-screen right
    {
        private _pos = ctrlPosition _x;
        _x ctrlSetPosition [
            (_pos select 0) + safeZoneW * 0.1,
            _pos select 1,
            _pos select 2,
            _pos select 3
        ];
        _x ctrlCommit 0;
        _x ctrlSetPosition _pos;
        _x ctrlCommit 0.3;
    } forEach [_ctrlBG, _ctrlAccent, _ctrlLabel, _ctrlText];

    // ---- Hold ----
    sleep _duration;

    // ---- Fade out ----
    _ctrlBG ctrlSetFade 1;
    _ctrlBG ctrlCommit 0.5;
    _ctrlAccent ctrlSetFade 1;
    _ctrlAccent ctrlCommit 0.5;
    _ctrlLabel ctrlSetFade 1;
    _ctrlLabel ctrlCommit 0.5;
    _ctrlText ctrlSetFade 1;
    _ctrlText ctrlCommit 0.5;

    sleep 0.6;

    // ---- Cleanup ----
    ctrlDelete _ctrlBG;
    ctrlDelete _ctrlAccent;
    ctrlDelete _ctrlLabel;
    ctrlDelete _ctrlText;
};
