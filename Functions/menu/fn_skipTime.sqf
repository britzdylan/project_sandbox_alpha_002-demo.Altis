/*
	Function:    fn_skipTime
	Description: Fades out the screen and audio, advances the mission clock by the
	             given number of hours, displays an elapsed-time title for 10 seconds,
	             then fades sound and screen back in.
	Parameters:  _hours (Number, default 6) — hours to skip forward
	Use when:    Advancing time between operations from the MISC menu.
*/
params [["_hours", 6, [0]]];

private _label = format [
	"+%1H00",
	_hours
];
private _text = format ["<t align='center' font='PuristaBold' size='2' shadow='1' shadowColor='#000000' color='#ffffff'>%1</t>", _label];
// disable player input
player enableSimulation false;
player allowDamage false;

// fade out audio and screen
1 fadeSound 0;
["skipTime"] call BIS_fnc_blackOut;
sleep 2;

skipTime _hours;
titleText [_text, "PLAIN", 1, true, true];
sleep 10;
titleFadeOut 2;

// fade back in
["skipTime"] call BIS_fnc_blackIn;
sleep 2;
5 fadeSound 1;

// re-enable player input
player enableSimulation true;
player allowDamage true;