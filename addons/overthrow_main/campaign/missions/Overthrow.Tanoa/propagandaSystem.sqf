if !(isServer) exitWith {};
_lasthour = 0;
waitUntil {sleep 1;server getVariable ["StartupType",""] != ""};
sleep 20;
while {true} do {
	_lasthour = date select 3;
	_totalStability = 0;
	_totalPop = 0;
	private _abandoned = server getVariable ["NATOabandoned",[]];
	{
		private _town = _x;
		private _townPos = server getVariable _town;
		private _commsAbandoned = ((_townPos call OT_fnc_nearestComms) select 1) in _abandoned;
		private _stability = server getVariable format["stability%1",_town];
		private _pop = server getVariable format["population%1",_town];
		_totalStability = _totalStability + _stability;
		_totalPop = _totalPop + _pop;
		if(_town in _abandoned) then {
			if(_commsAbandoned) then {
				//Resistance controls both, stability goes up if theres police
				_police = server getVariable [format["police%1",_town],0];
				if (_police > 0) then {
					[_town,floor(_police / 2)] call stability;
				};
			}else{
				//NATO owns the tower but not the town, stability goes down
				if((random 100) > 80) then {
					[_town,-1] call stability;
				};
			};
		}else{
			if(_commsAbandoned) then {
				//Resistance controls tower but not town, stability goes down
				_police = server getVariable [format["garrison%1",_town],0];
				_chance = 20;
				if(_police < 4) then {
					_chance = 50;
				};
				if(_police < 2) then {
					_chance = 80;
				};
				if((random 100) < _chance) then {
					[_town,-2] call stability;
				}else{
					if((random 100) > 50) then {
						[_town,-1] call stability;
					};
				};
			};
		};
	}foreach(OT_allTowns);
	server setVariable ["stabilityTanoa",_totalStability / (count OT_allTowns),true];
	server setVariable ["populationTanoa",_totalPop,true];
	waitUntil {sleep 5;(date select 3) != _lasthour}; //do actions on the hour
};
