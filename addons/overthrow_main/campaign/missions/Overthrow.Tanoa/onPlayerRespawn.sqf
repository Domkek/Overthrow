if (isDedicated) exitWith {};
_new = _this select 0;
_old = _this select 1;

if(isNull(_old)) exitWith {};

titleText ["", "BLACK FADED", 0];

waitUntil {alive player};
player setCaptive true;
player allowDamage false;

private _money = player getVariable ["money",0];
private _take = floor(_money * 0.25);
if(_take > 0) then {
	[-_take] call money;
};

removeHeadgear player;
removeAllWeapons player;
removeAllAssignedItems player;
removeGoggles player;
removeBackpack player;
removeVest player;

player addWeapon "ItemMap";

sleep 2;

_housepos = _old getVariable "home";
_town = _housepos call OT_fnc_nearestTown;
player setPos _housepos;
_clothes = player getVariable ["uniform",(OT_clothes_guerilla call BIS_fnc_selectRandom)];
player forceAddUniform _clothes;
[] execVM "setupPlayer.sqf";

call {	
	disableSerialization;
	_display = uiNameSpace getVariable "OT_statsHUD";
	if(isNil "_display") exitWith{};
	_setText = _display displayCtrl 1001;
	_setText ctrlSetStructuredText (parseText "");
	_setText ctrlCommit 0;
};

titleText ["", "BLACK IN", 5];



sleep 5;
player allowDamage true;

