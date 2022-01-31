// Load the mission admin page.
null = execVM "\lt_template_base\briefing\admin.sqf";

// Load the checklist
null = execVM "\lt_template_base\briefing\checklist.sqf";

//// Uncomment the following lines if you don't want to make use of the modules.

_mis = player createDiaryRecord ["diary", ["Missie","
<font face='PuristaBold' color='#FFBA26' size='16'>SITUATIE</font><br/>
Wij zijn een groep soldaten die tegen de grote boze tegenstander stand dienen te houden! De tot de tanden bewapende OpFor die alles in de strijd gooit om ons te doden. We kunnen alleen op onszelf rekenen. Helikopters en vliegtuigen zijn na 30 minuten beschikbaar voor extractie- en CAS gebruik.<br/><br/>

<font face='PuristaBold' color='#FFBA26' size='16'>MISSIE</font><br/>
• Kies een leuke plek om te verdedigen (hou 400m-800m spawn range in acht)<br/>
• Zet je schrap en blijf leven!<br/>
• Ben je dood? Na 30 minuten mag gerespawned worden als CAS en extractie<br/>
• Iedereen in de heli en onderweg naar veiligheid; call it!
"]];
