// Missebriefing v2 
// Niet aanraken tenzij je weet wat je doet 

private _getlocalizedstring = {
    params ["_setting"];
    
    _setting = toUpper (localize (((cba_settings_default getVariable _setting select 3) select 1) select (missionnamespace getVariable _setting)));
    
    _setting
};

player removeDiarySubject "cba_help_docs";
player removeDiarySubject "units";
player removeDiarySubject "Diary";
player removeDiarySubject "Statistics";
player removeDiarySubject "Log";

player createDiarySubject ["Briefing", "Briefing"];

// Vervangend Admin.sqf 

private ["_staff"];

// Flendurs, SvenBrandt99, Tybalty, L0neSentinel
_staff = ["76561197972110272","76561198069718715","76561198042684200","76561198028914656"];

if (serverCommandAvailable "#kick" or getPlayerUID player in _staff) then
{

	_briefing ="
	<br/>
	<font size='18'>ADMIN SECTIE</font><br/>
	Ultieme Hackz0rs gebied voor administratie
	<br/><br/>
	";

	_tasks 	= player call BIS_fnc_tasksUnit;
	diag_log format ["LT template DEBUG: Taskarray: %1",_tasks];

	_side 	= side player;

	lt_fnc_setTaskState = {
		PRIVATE ["_taskIndex", "_state", "_side","_taskArray","_task"];
		_taskIndex = _this select 0;
		_state = _this select 1;
		_side = _this select 2;
		_taskArray = player call BIS_fnc_tasksUnit;
		_task = _taskArray select _taskIndex;
		[_task, _state, true] remoteExec ['BIS_fnc_taskSetState', _side, true];
	};

	_briefing = _briefing + "<font size='18'>Tasks</font><br/>";
	if (count _tasks > 0) then {
		{
			_taskID = _x;
			_taskIndex = (player call BIS_fnc_tasksUnit) find _x;
			_TaskDescriptionArray = _taskID call BIS_fnc_taskDescription;
			_TaskDescription = _TaskDescriptionArray select 1;
			_briefing = _briefing + format [
			"<br/><font size='14'>Task: %2</font><br/>
			Set state to: <executeClose expression=""[%1, 'Succeeded', %3] call lt_fnc_setTaskState;"">'Succeeded'</executeClose>
			 or <executeClose expression=""[%1, 'Failed', %3] call lt_fnc_setTaskState;"">'Failed'</executeClose><br/><br/>", _taskIndex, _TaskDescription, _side];
		} forEach _tasks;
	} else {
		_briefing = _briefing + "No tasks specified at beginning<br/><br/>";
	};

	_title = [];
	_ending = [];
	_endings = [];

	_i = 1;
	while {true} do {
		_title = getText (missionconfigfile >> "CfgDebriefing" >> format ["end%1",_i] >> "title");
		_description = getText (missionconfigfile >> "CfgDebriefing" >> format ["end%1",_i] >> "description");
		if (_title == "") exitWith {};
		_ending = [_i,_title,_description];
		_endings append ([_ending]);
		_i = _i + 1;
	};

	_briefing = _briefing + "
	<font size='18'>ENDINGS</font><br/>
	Beschikbare eindes.<br/>
	";
	diag_log format ["LT template DEBUG: Endings: %1",_endings];
	{
		//_end = _this select 0;
		_briefing = _briefing + format [
		"<execute expression=""[[%1],'f_fnc_mpEnd',false] spawn BIS_fnc_MP;"">'end%1'</execute> - %2<br/>"
		,_x select 0,_x select 1,_x select 2];
	} forEach _endings;

	_briefing = _briefing + "
	<br/><br/><font face='PuristaBold' color='#FFBA26'>SAFE START CONTROL</font><br/>
	<execute expression=""lt_param_timer = lt_param_timer + 1; publicVariable 'lt_param_timer'; hintsilent format ['Mission Timer: %1',lt_param_timer];"">
	Increase Safe Start timer by 1 minute</execute><br/>
	<execute expression=""lt_param_timer = lt_param_timer - 1; publicVariable 'lt_param_timer'; hintsilent format ['Mission Timer: %1',lt_param_timer];"">
	Decrease Safe Start timer by 1 minute</execute><br/>
	<execute expression=""[[[],'functions\f\safeStart\f_safeStart.sqf'],'BIS_fnc_execVM',true]  call BIS_fnc_MP;
	hintsilent 'Safe Start started!';"">
	Begin Safe Start timer</execute><br/>
	<execute expression=""lt_param_timer = -1; publicVariable 'lt_param_timer';
	[['SafeStartMissionStarting',['Mission starting now!']],'bis_fnc_showNotification',true] call BIS_fnc_MP;
	[[false],'f_fnc_safety',playableUnits + switchableUnits] call BIS_fnc_MP;
	hintsilent 'Safe Start ended!';"">
	End Safe Start timer</execute><br/>
	<execute expression=""[[true],'f_fnc_safety',playableUnits + switchableUnits] call BIS_fnc_MP;
	hintsilent 'Safety on!' "">
	Force safety on for all players</execute><br/>
	<execute expression=""[[false],'f_fnc_safety',playableUnits + switchableUnits] call BIS_fnc_MP;
	hintsilent 'Safety off!' "">
	Force safety off for all players</execute><br/><br/>
	";

	player createDiaryRecord ["Briefing", ["Admin Menu",_briefing]];


};

_mis = player createDiaryRecord ["Briefing", ["Checklist", "
<br/><font face='PuristaBold' color='#FFBA26'>Leidende elementen</font><br/>
- Is de briefing op discord van te voren gelezen?<br/>
- Is de opdracht duidelijk?<br/>
- Weet je de compositie van de vijand?<br/>
- Heb je alle spullen die je nodig hebt?<br/>
- Is de route de meest veilige optie?<br/>
- Wat gebeurt er tijdens vijandig contact?<br/>
- Wat zijn de radiokanalen in gebruik?<br/>
- Is er een plan B en ERV?<br/>
- Weet iedereen alle bovengenoemde zaken?<br/>
<br/><font face='PuristaBold' color='#FFBA26'>Iedereen</font><br/>
- Heb je alles wat je nodig hebt om je taak te vervullen?<br/>
- Ben je bekend met de SOP van Lowlands Tactical?<br/>
- Weet je wie de leidinggevenden zijn?<br/>
- Doet je radio het?<br/>
"]];

// Daadwerkelijke briefing. 
// Gebruik <marker name='name'>Titel</marker> om links in de briefing te maken 

_mis = player createDiaryRecord ["Briefing", ["OPORD", "
<br/><font face='PuristaBold' color='#FFBA26'>SITUATIE</font><br/>
This is a test
"]];

// CBA Medical setting 

private _fatalplayer = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", ["ace_medical_statemachine_fatalinjuriesplayer"] call _getlocalizedstring];
private _fatalAi = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", ["ace_medical_statemachine_fatalinjuriesAI"] call _getlocalizedstring];
private _unconAi = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", ["Uit", "Aan"] select ace_medical_statemachine_AIUnconsciousness];

private _advBand = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", ["ace_medical_treatment_advancedBandages"] call _getlocalizedstring];
private _advMedi = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", ["Uit", "Aan"] select ace_medical_treatment_advancedMedication];

private _bleedCoeff = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", ace_medical_bleedingCoefficient];
private _sponWake = format ["<font face='PuristaBold' color='#FFBA26'>%1%2</font><br/>", (ace_medical_spontaneousWakeUpChance*100), "%"];
private _carditime = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", [ace_medical_statemachine_cardiacArresttime] call BIS_fnc_secondstoString];

private _whoEpi = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", ["ace_medical_treatment_medicEpinephrine"] call _getlocalizedstring];
private _whoIv = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", ["ace_medical_treatment_medicIV"] call _getlocalizedstring];
private _whoPak = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", ["ace_medical_treatment_medicPAK"] call _getlocalizedstring];
private _conPak = format ["<font face='PuristaBold' color='#FFBA26'>%1</font>", ["Uit", "Aan"] select ace_medical_treatment_consumePAK];

private _text = format ["
    <br/><font face='PuristaBold' color='#FFBA26' size='16'>MEDICAL SETTINGS</font><br/>
    <font color='#D7DBD5'>Fatale verwondingen Speler: </font>%1
    <font color='#D7DBD5'>Fatale verwondingen AI: </font>%2
    <font color='#D7DBD5'>AI Bewusteloosheid: </font>%3
    <br/>
    <font color='#D7DBD5'>Advanced Bandages: </font>%4
    <font color='#D7DBD5'>Advanced Medicatie: </font>%5
    <br/>
    <font color='#D7DBD5'>Bloeden Coefficient: </font>%6
    <font color='#D7DBD5'>Kans om bij te komen: </font>%7
    <font color='#D7DBD5'>Hartstilstand tijd: </font>%9
    <br/>
    <font color='#D7DBD5'>Epinephrine: </font>%10
    <font color='#D7DBD5'>IV Transfusie: </font>%11
    <font color='#D7DBD5'>PAK: </font>%12
    <font color='#D7DBD5'>Gebruik PAK: </font>%13
", _fatalplayer, _fatalAi, _unconAi, _advBand, _advMedi, _bleedCoeff, _sponWake, _carditime, _whoEpi, _whoIv, _whoPak, _conPak];
_text = [_text, "&", "and"] call CBA_fnc_replace;

player createDiaryRecord ["Briefing", ["Medical", _text], taskNull, "", false];
