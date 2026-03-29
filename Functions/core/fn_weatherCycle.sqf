// ============================================================
// OSF_fnc_weatherCycle
// Dynamic weather cycle. Randomly transitions between weather
// states at intervals. Runs as a spawned loop.
// 
// Weather states: clear, overcast, light rain, heavy rain, fog.
// Transitions happen every 30-60 minutes of real time.
// Uses forceWeatherChange for smooth transitions.
// 
// params: none
// Returns: nothing (infinite loop — spawn, don't call)
// Usage:  [] spawn OSF_fnc_weatherCycle;
// ============================================================

#include "..\..\scripts\constants.hpp"

["core", "Weather cycle starting.", OSF_LOG_INFO] call OSF_fnc_log;

// Initial weather
0 setOvercast 0.3;
0 setRain 0.4;
0 setFog 0.3;
forceWeatherChange;

while { true } do {
	// Wait 30-60 real minutes between transitions
	private _wait = OSF_WEATHER_INTERVAL + random OSF_WEATHER_INTERVAL;
	sleep _wait;

	    // Pick a random weather state
	private _roll = random 1;

	private _overcast = 0;
	private _rain = 0;
	private _fog = 0;
	private _label = "";

	if (_roll < 0.35) then {
		// fog
		_overcast = 0.3 + random 0.2;
		_rain = 0;
		_fog = 0.6 + random 0.3;
		_label = "fog";
	} else {
		if (_roll < 0.55) then {
			// Heavy rain
			_overcast = 0.8 + random 0.15;
			_rain = 0.8 + random 0.2;
			_fog = 0.05 + random 0.15;
			_label = "heavy rain";
		} else {
			if (_roll < 0.75) then {
				// overcast
				_overcast = 0.4 + random 0.2;
				_rain = 0;
				_fog = random 0.05;
				_label = "overcast";
			} else {
				if (_roll < 0.9) then {
					// Light rain
					_overcast = 0.6 + random 0.15;
					_rain = 0.3 + random 0.2;
					_fog = random 0.1;
					_label = "light rain";
				} else {
					// Clear
					_overcast = 0.05 + random 0.15;
					_rain = 0;
					_fog = 0;
					_label = "clear";
				};
			};
		};
	};

	OSF_WEATHER_TRANSITION setOvercast _overcast;
	OSF_WEATHER_TRANSITION setRain _rain;
	OSF_WEATHER_TRANSITION setFog _fog;
	forceWeatherChange;

	["core", format ["Weather -> %1 (overcast: %2, rain: %3, fog: %4)",
	_label, _overcast toFixed 2, _rain toFixed 2, _fog toFixed 2], OSF_LOG_VERBOSE] call OSF_fnc_log;
};