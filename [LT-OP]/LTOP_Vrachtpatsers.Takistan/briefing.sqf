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
<font face='PuristaBold' color='#A34747'>Vijandige Eenheden</font><br/>
(1) Wie: PFF (Pakmanie freedom forces)<br/>
(2) Wat: Bezetting van de AOR waarbij ze onze bewegingen proberen te belemmeren.<br/>
(3) Waar: MSR Omega, Takistan<br/>
(4) Wanneer: As we speak voeren ze druk uit in de AOR.<br/>
(5) Waarmee: KKW + lichte voertuigen + (VB/Suicide) IED.<br/>
(6) Waarom: De route is tevens voor de PFF van belang voor hun bevoorrading.<br/>
<br/><font face='PuristaBold' color='#A3E0FF'>Eigen Eenheden</font><br/>
Taskforce: Lowtac NLD light forces<br/>
<br/><font face='PuristaBold' color='#A3FFA3'>Onderbevelstelling</font><br/>
Taskforce: 336 squadron	(1x NH90 Armed)<br/>
<br/><font face='PuristaBold' size='16' color='#FFBA26'>OPDRACHT</font><br/>
Bereid voor en voer een konvooi uit vanuit <marker name='start'>FOB India</marker> over route OMEGA richting <marker name='end'>FOB India</marker>, waarbij er een tussenstop gedaan dient te worden voor het leveren van humanitaire hulp op <marker name='idap'>Waterfall</marker>. Tevens dient hier informatie verzameld te worden ter bevordering van de IDAP operatien. U bent zelf verantwoordelijk voor de beveiliging van het konvooi.<br/><br/>
<font face='PuristaBold' size='16' color='#FFBA26'>UITVOERING</font><br/>
<font face='PuristaBold' color='#A3FFA3'>Oogmerk</font><br/>
(1) Rol: Doormiddel van een goede kaart studie en onderkenning van eventuele dreigingen de lokale bevolking helpen en de rest goederen op <marker name='end'>FOB India</marker> af te leveren.<br/>
(2) Beoogd effect: Goodwill krijgen van de lokale bevolking en onze eigen troepen te bevoorraden, waarbij het verlies van eigen personeel en materiaal geminimaliseerd moet worden.<br/><br/>
<font face='PuristaBold' color='#A3FFA3'>Operatieconcept</font><br/>
- Fase 1: Voorbereiding<br/>
Maak een plan op de kaart en zorg dat de VLT’en weten wat er verwacht wordt, hun gaan op hun beurt de groep inlichten en eigen kaart studie plegen.<br/><br/>
- Fase 2: Uitvoering<br/>
Voer de gemaakte plannen uit waarbij rekening gehouden moet worden dat er gaande de operatie intel vergaard kan worden.<br/><br/>
- Fase 3: Afronding<br/>
Na de operatie nabespreken waarbij besproken kan worden wat goed ging en wat beter kan de volgende keer.<br/><br/>
<font face='PuristaBold' color='#A3FFA3'>Coördinerende bepalingen</font><br/>
- Gevechtstenue met LT vlag geplaatst<br/>
- Standaard uitrusting zoals het template beschrijft (geen hamster momenten)<br/>
- U neemt 2 vrachtwagens mee t.b.v. de herbevoorrading tijdens de missie<br/>
<br/><font face='PuristaBold' size='16' color='#FFBA26'>Logistiek</font><br/>
<font face='PuristaBold' color='#A3FFA3'>Logistiek operatieconcept</font><br/>
De groepen zullen voorzien worden van soft-tops, hierin zullen extra materialen in zitten. Op de persoon zal 2x combat-load aanwezig zijn bij vertrek.<br/><br/>
<font face='PuristaBold' color='#A3FFA3'>Materieellogistiek</font><br/>
De GC heeft beschikking over 1x NH-90 voor eventuele steun tijdens de missie. Voertuigen zullen doormiddel van eigen BDR weer inzetbaar gemaakt moeten worden, er is geen herstelgroep in de AOR om herstel werkzaamheden uit te voeren.<br/><br/>
<font face='PuristaBold' color='#A3FFA3'>Personeelslogistiek</font><br/>
(1) Gewonden dienen door de medic/groepsleden geholpen te worden, er is geen medevac!<br/>
(2) De Medische HEMTT is een mobiele respawn ter bevordering van de gameplay flow.<br/>
(3) Zorg voor een gewondennest indien zich een grootschalige calamiteiten voordoen.<br/><br/>
"]];

// CBA Medical setting 

private _fatalplayer = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", ["ace_medical_statemachine_fatalinjuriesplayer"] call _getlocalizedstring];
private _fatalAi = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", ["ace_medical_statemachine_fatalinjuriesAI"] call _getlocalizedstring];
private _unconAi = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", ["Uit", "Aan"] select ace_medical_statemachine_AIUnconsciousness];

private _advBand = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", ["ace_medical_treatment_advancedBandages"] call _getlocalizedstring];
private _advMedi = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", ["Uit", "Aan"] select ace_medical_treatment_advancedMedication];

private _bleedCoeff = format ["<font face='PuristaBold' color='#FFBA26'>%1</font><br/>", ace_medical_bleedingCoefficient];
private _sponWake = format ["<font face='PuristaBold' color='#FFBA26'>%1%2</font><br/>", (ace_medical_spontaneousWakeUpChance*100), "%"];
private _cprSuccess = format ["<font face='PuristaBold' color='#FFBA26'>%1%2</font><br/>", (ace_medical_treatment_cprSuccessChance*100), "%"];
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
    <font color='#D7DBD5'>Reanimatie success kans: </font>%8
    <font color='#D7DBD5'>Hartstilstand tijd: </font>%9
    <br/>
    <font color='#D7DBD5'>Epinephrine: </font>%10
    <font color='#D7DBD5'>IV Transfusie: </font>%11
    <font color='#D7DBD5'>PAK: </font>%12
    <font color='#D7DBD5'>Gebruik PAK: </font>%13
", _fatalplayer, _fatalAi, _unconAi, _advBand, _advMedi, _bleedCoeff, _sponWake, _cprSuccess, _carditime, _whoEpi, _whoIv, _whoPak, _conPak];
_text = [_text, "&", "and"] call CBA_fnc_replace;

player createDiaryRecord ["Briefing", ["Medical", _text], taskNull, "", false];
