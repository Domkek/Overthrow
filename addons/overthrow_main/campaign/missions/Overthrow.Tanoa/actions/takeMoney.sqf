OT_context = _this select 0;

private _password = OT_context getVariable ["password",""];

if(_password == "") exitWith {
	private _in = OT_context getVariable ["money",0];

	inputHandler = {
		_val = parseNumber(ctrltext 1400);
		_cash = player getVariable ["money",0];
		_in = OT_context getVariable ["money",0];
		if(_val > _in) then {_val = _in};
		if(_val > 0) then {
			[_val] call money;
			OT_context setVariable ["money",_in - _val,true];
		};
	};

	[format["How much to take? ($%1 Total)",[_in, 1, 0, true] call CBA_fnc_formatNumber],100] spawn inputDialog;
};

inputHandler = {
	private _password = OT_context getVariable ["password",""];
	private _pw = ctrlText 1400;
	if(_pw != _password) exitWith {"Wrong password" call notify_minor};
	private _in = OT_context getVariable ["money",0];

	inputHandler = {
		_val = parseNumber(ctrltext 1400);
		_cash = player getVariable ["money",0];
		_in = OT_context getVariable ["money",0];
		if(_val > _in) then {_val = _in};
		if(_val > 0) then {
			[_val] call money;
			OT_context setVariable ["money",_in - _val,true];
		};
	};

	[format["How much to take? ($%1 Total)",[_in, 1, 0, true] call CBA_fnc_formatNumber],100] spawn inputDialog;
};

["Please enter password",""] spawn inputDialog;