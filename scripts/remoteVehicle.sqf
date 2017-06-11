/*
	Remote vehicle script by salival (https://github.com/oiad)
*/

private ["_characterID","_display","_fuel","_group","_keyFound","_keyID","_keyName","_option","_time","_vehicle","_vehicleType"];

_keyName = _this select 0;
_option = _this select 1;

disableSerialization;

_display = findDisplay 106;
_display closeDisplay 0;

_keyID = 0;
{
	if (configName(inheritsFrom(configFile >> "CfgWeapons" >> _x)) in ["ItemKeyYellow","ItemKeyBlue","ItemKeyRed","ItemKeyGreen","ItemKeyBlack"]) then {
		if (_x == _keyName) then {
			_keyID = getNumber(configFile >> "CfgWeapons" >> _x >> "keyid");
		};
	};
} forEach (items player);

if (_keyID == 0) exitWith {systemChat "No valid keys in your toolbelt."};

_keyFound = false;
{
	_vehicleType = typeOf _x;
	_characterID = parseNumber (_x getVariable ["CharacterID","0"]);
	if ((_characterID == _keyID) && {_vehicleType isKindOf "Air" || _vehicleType isKindOf "LandVehicle" || _vehicleType isKindOf "Ship"}) exitWith {
		_keyFound = true;
		_vehicle = _x;
	};
} count vehicles;

if (!_keyFound) exitWith {systemChat "Unable to find a valid vehicle for this key.";};
if (!alive _vehicle) exitWith {systemChat "The vehicle for this key has been destroyed.";};

if (_option == 1) then {
	_group = units group player;

	systemChat format ["Ejecting all players not in your group from: %1",_vehicleType];

	{
		if !(_x in _group) then {
			_x action ["eject",_vehicle];
			systemChat format ["Ejecting %1, they are NOT in your group.",name _x];
		};
	} forEach (crew _vehicle);
};

if (_option == 2) then {
	systemChat format ["Toggling engine on/off in: %1",_vehicleType];
	if (isEngineOn _vehicle) then {
		if (_vehicle isKindOf "Helicopter") then { // This is needed because dayz_engineSwitch won't turn off the engine for a helicopter.
			_fuel = fuel _vehicle;
			_vehicle setFuel 0;
			player action ["engineOff",_vehicle];
			uiSleep 4; 
			_vehicle setFuel _fuel;
		} else {
			[_vehicle,false] call dayz_engineSwitch;
		};
	} else {
		[_vehicle,true] call dayz_engineSwitch
	};
};

if (_option == 3) then {
	systemChat format ["Unlocking: %1",_vehicleType];
	PVDZE_veh_Lock = [_vehicle,false];
	_time = diag_tickTime;

	if (local _vehicle) then {
		PVDZE_veh_Lock call local_lockUnlock;
	} else {
		publicVariable "PVDZE_veh_Lock";
		//Wait for lock status to update over network (can take up to a few seconds)
		waitUntil {uiSleep 0.1;(!locked _vehicle or (diag_tickTime - _time > 4))};
	};
};

if (_option == 4) then {
	systemChat format ["Locking: %1",_vehicleType];
	PVDZE_veh_Lock = [_vehicle,true];
	_time = diag_tickTime;

	if (local _vehicle) then {
		PVDZE_veh_Lock call local_lockUnlock;
	} else {
		publicVariable "PVDZE_veh_Lock";
		//Wait for lock status to update over network (can take up to a few seconds)
		waitUntil {uiSleep 0.1;(locked _vehicle or (diag_tickTime - _time > 4))};
	};
};