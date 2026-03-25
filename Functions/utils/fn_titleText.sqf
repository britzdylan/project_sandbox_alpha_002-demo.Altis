// ============================================================
// OSF_fnc_titleText
// Returns a styled structured-text string for use with titleText.
// Consistent style: centered, PuristaBold, white, drop shadow.
// 
// params:
//   _label (STRING) — text to display
//   _size  (NUMBER, optional — default 2) — font size multiplier
//   _color (STRING, optional — default "#ffffff") — hex color
// 
// Returns: formatted string
// Usage:
//   titleText [["My Title"] call OSF_fnc_titleText, "PLAIN", 1];
//   titleText [["+6H00", 2, "#ffcc00"] call OSF_fnc_titleText, "PLAIN", 1];
// ============================================================

params ["_label", ["_size", 2], ["_color", "#ffffff"]];

private _text = format ["<t align='center' font='PuristaBold' size='%1' shadow='1' shadowColor='#000000' color='%2'>%3</t>", _size, _color, _label];
_text;