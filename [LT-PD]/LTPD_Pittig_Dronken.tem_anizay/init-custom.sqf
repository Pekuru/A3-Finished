// Place you mission specific content here.

if (call ALIVE_fnc_isServerAdmin) then {
  _ts_main = ["townsweep_main","Defence","",{},{true}] call ace_interact_menu_fnc_createAction;
  [player, 1, ["ACE_SelfActions"], _ts_main ] call ace_interact_menu_fnc_addActionToObject;

  _action = ["townsweep_select_AO","Select AO","",{execVM "town_select.sqf";},{call ALIVE_fnc_isServerAdmin}] call ace_interact_menu_fnc_createAction;
  [player, 1,["ACE_SelfActions","townsweep_main"], _action] call ace_interact_menu_fnc_addActionToObject;
};
