// Load the mission admin page.
null = execVM "\lt_template_base\briefing\admin.sqf";

// Load the checklist
null = execVM "\lt_template_base\briefing\checklist.sqf";

//// Uncomment the following lines if you don't want to make use of the modules.

_mis = player createDiaryRecord ["diary", ["Situatie","
<font face='PuristaBold' color='#FFBA26' size='16'>SITUATIE</font><br/>
Welkom op Malden. Ik hoop dat iedereen een goede nachtrust gehad heeft, want nu we hier zijn, is er veel te doen. Nadat de 2037 wereldweide economische crisis tot massaontslagen en politieke instabiliteit binnen CSAT heeft geleidt, heeft de Zuid-Afrikaanse divisie van het bontgenootschap Malden geannexeerd om haar reeds ontdekte oliereservoir te claiemn om haar economie terug op gang te brengen. Vredesbesprekingen zijn tot dusver vruchteloos en daarom heeft de ondergedoken regering een directe interventie aangevraagd bij de NAVO. Onder druk van Rusland, die nog steeds 50/50 verdeeld is over toetreden tot de NAVO of CSAT, lanceert een coalitie aan landen een invasie - De twee grootste coalities ter wereld trekken ten strijde.
<br/><br/>
<font face='PuristaBold' color='#A34747'>Vijandige Eenheden</font><br/>
De CSAT Scimitar Divisie is verantwoordelijk voor de annexatie. Deze eenheid onder leiding van Generaal Fashoev staat bekend om brutale slagkracht te leveren waarbij vaak 'scorched earth' tactieken worden toegepast. Deze eenheid is over het hele eiland verspeidt.
<br/><br/>
<font face='PuristaBold' color='#A3E0FF'>Eigen Troepen</font><br/>
Taskforce Aegis is de NAVO reactiemacht welke Malden terug dient te veroveren. De taskforce bestaat uit Amerikaanse, Britse, Nederlandse, Duitse, Poolse en Franse troepen onder leiding van Generaal George S. Hammond. 
"]];

_mis = player createDiaryRecord ["diary", ["Missie","
<font face='PuristaBold' color='#FFBA26' size='16'>DOELEN</font><br/>
De eerste stap in het terugveroveren van het eiland is het uitschakelen van het zuid-oostelijke eiland. Dit eiland is de thuisbasis van het SADC (Scimitar Air Defense Command) met AA en Radar hardware verspreidt over het eiland. Om luchtoverheersing te claimen dienen deze uitgeschakeld te worden.
<br/><br/>
- Vernietig Surface-To-Air raketsystemen [<marker name='derp1'>1</marker>] [<marker name='derp2'>2</marker>]
<br/>
- Vernietig Cronus Early Warning Air Radar [<marker name='derp3'>1</marker>]
<br/><br/>
<font face='PuristaBold' color='#A34747'>Vijandige Eenheden</font><br/>
(Zie kaart)
<br/><br/>
<font face='PuristaBold' size='16' color='#FFBA26'>UITVOERING</font><br/>
Lowlands Tactical zal na eigen inzicht landen op het eiland met geleverde LCU en lichte vervoersmiddelen om vervolgens de doelen uit te schakelen.
<br/><br/>
<font face='PuristaBold' color='#A3FFA3'>Andere bepalingen</font><br/>
Mogelijkerwijs is er een kans dat er een QRF standby staan. De exacte locatie hebben we vanwege ECM niet kunnen localiseren.
"]];
