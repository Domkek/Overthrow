private ["_id","_params","_town","_posTown","_active","_groups","_civs","_numCiv","_shops","_houses","_stability","_pop","_count","_mSize","_civTypes","_hour","_range","_found"];
if (!isServer) exitwith {};

_active = false;

_count = 0;
_id = _this select 0;
_town = _this select 3;
_groups = [];

_civs = []; //Stores all civs for tear down

waitUntil{spawner getVariable _id};

while{true} do {
	//Do any updates here that should happen whether spawned or not
	
	//Main spawner
	if !(_active) then {
		if (spawner getVariable _id) then {
			
			_active = true;
			//Spawn stuff in
			
			_pop = server getVariable format["population%1",_town];
			_stability = server getVariable format ["stability%1",_town];
			_posTown = server getVariable _town;
			
			_mSize = 350;
			if(_town in AIT_capitals) then {
				_mSize = 800;
			};
			
			if(_pop > 15) then {
				_numCiv = round(_pop * AIT_spawnCivPercentage);
			}else {
				_numCiv = _pop;
			};
			
			_hour = date select 3;
			
			_civTypes = AIT_civTypes_locals;

			if(_pop > 600) then {
				_civTypes = _civTypes + AIT_civTypes_expats + AIT_civTypes_tourists;
			};

			if(_hour > 17 || _hour < 9) then {
				//spawn less people outside 9-5 hours
				_numCiv = round(_numCiv * 0.5);
			};			
			_count = 0;
			
			_pergroup = 2;
			if(_numCiv < 10) then {_pergroup = 1};
			if(_numCiv > 30) then {_pergroup = 3};
			if(_numCiv > 50) then {_pergroup = 4};
			if(_numCiv > 70) then {_pergroup = 5};
			if(_numCiv > 100) then {_pergroup = 8};
			_idd = 1;
			while {_count < _numCiv} do {
				_groupcount = 0;
				_group = createGroup civilian;
				_groups pushback _group;
				_group setGroupId [format["%1 %2-1",_town,_idd],""];
				_idd = _idd + 1;
				while {(_groupcount < _pergroup) and (_count < _numCiv)} do {
					_pos = [[[_posTown,_mSize]]] call BIS_fnc_randomPos;				
					
					_civ = _group createUnit [_civTypes call BIS_fnc_selectRandom, _pos, [],0, "NONE"];
					_civ setBehaviour "SAFE";
					[_civ] spawn initCivilian;
					_civs pushBack _civ;				
					_count = _count + 1;
					_groupcount = _groupcount + 1;
				};		
				sleep 0.01;
			};
			{
				_x addCuratorEditableObjects [_civs,true];
			} forEach allCurators;
			
			sleep 1;
			{
				_x setDamage 0;				
			}foreach(_civs);			
		};
	}else{
		if (spawner getVariable _id) then {
			//Do updates here that should happen only while spawned
			//...
		}else{		
			_active = false;
			//Tear it all down
			{
				if !(_x call hasOwner) then {
					deleteVehicle _x;
				};				
			}foreach(_civs);
			{				
				deleteGroup _x;								
			}foreach(_groups);
			_civs = [];
			_groups = [];
		};
	};
	sleep 1;
};