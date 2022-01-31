// TFR settings
#include "\lt_template_base\TFR\settings.sqf"

// Briefing file.
null = execVM "briefing.sqf";

// MAKE SURE THE PLAYER INITIALIZES PROPERLY
if (!isDedicated && player != player) then { waitUntil {player == player && time > 0.3}; } else { waitUntil {time > 0.3}; };

// Spelers zien niks
titleCut ["", "BLACK FADED", 999];

// Set Camo, Gear and TFR. And in this order!
#include "\lt_template_base\gear\setCamo.sqf"
#include "\lt_template_base\gear\setGear.sqf"
#include "\lt_template_base\gear\setTFR.sqf"

// Settings common to all scenarios. (Also loaded in onPlayerRespawn.sqf)
#include "\lt_template_base\init\common.sqf"

// Place Mission Specific commands in this file.
#include "init-custom.sqf"

// Fade in
titleCut ["", "BLACK IN", 10];

[
	[
		[format ["[LT-OP] VRACHTPATSERS"],"align = 'center' shadow = '2' size = '1' font='PuristaBold'","#FFBA26"],
		["","<br/>"],
		[format ["Missiemaker: Pek"],"align = 'center' shadow = '2' size = '0.75' font='PuristaBold'","#FFFFFF"],
		["","<br/>"],
		[format ["Vergeet de safety niet!"],"align = 'center' shadow = '2' size = '0.5' font='PuristaBold'","#A34747"],
		["","<br/>"]
	],safeZoneX+0.0,safeZoneY+0.8
] spawn BIS_fnc_typeText2;
