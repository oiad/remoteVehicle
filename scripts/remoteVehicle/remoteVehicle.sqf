/*
	Remote vehicle script by salival (https://github.com/oiad)
*/

private ["_characterID","_checkDistance","_display","_distance","_fuel","_group","_vehicleFound","_keyID","_keyName","_option","_time","_vehicle","_vehicleType","_index","_control","_keyDisplay","_exit"];

if (isNil "rv_init") then {
	if (getText (configFile >> "CfgMods" >> "DayZ" >> "version") == "DayZ Epoch 1.0.6.1") then {epoch_tempKeys = compile preprocessFileLineNumbers "scripts\remoteVehicle\epoch_tempKeys.sqf";}; // This can be removed when 1.0.6.2 comes out.
	rv_vehicleInfo = compile preprocessFileLineNumbers "scripts\remoteVehicle\vehicleInfo.sqf";
	rv_init = true;
};

if (dayz_actionInProgress) exitWith {localize "str_player_actionslimit" call dayz_rollingMessages;};
dayz_actionInProgress = true;

_keyName = _this select 0;
_option = _this select 1;

_checkDistance = true; // Check to see if the player is too far away from the remote
_distance = 300; // Maximum distance the player can be away from the vehicle to be able to use the remote.

disableSerialization;

_exit = {
	dayz_actionInProgress = false;
	rv_vehicleList = nil;
	rv_selected = nil;
};

_display = findDisplay 106;
_display closeDisplay 0;

_keyList = call epoch_tempKeys;
_keyID = 0;

_keyID = (_keyList select 0) select ((_keyList select 2) find _keyName);
_foundPos = (_keyList select 0) find _keyID;

if (_foundPos >= 0) then {
	_keyDisplay = (_keyList select 1) select _foundPos;
};

if (_foundPos == -1) exitWith {systemChat "No valid keys in your toolbelt."; call _exit;};

rv_vehicleList = [];
_vehicleFound = false;
{
	_vehicleType = typeOf _x;
	_characterID = _x getVariable ["CharacterID","0"];
	if ((_characterID == _keyID) && {_vehicleType isKindOf "Air" || _vehicleType isKindOf "LandVehicle" || _vehicleType isKindOf "Ship"}) then {
		_vehicleFound = true;
		rv_vehicleList set [count rv_vehicleList,_x];
	};
} count vehicles;

if (count rv_vehicleList > 1) then {
	rv_isOk = false;

	createDialog "remoteVehicle";

	_display = uiNamespace getVariable["rv_dialog", displayNull];
	_display displayCtrl 8801 ctrlSetText(format ["Remote Vehicle - Vehicles for %1",_keyDisplay]);

	_control = ((findDisplay 8800) displayCtrl 8802);
	lbClear _control;
	{
		_control lbAdd getText(configFile >> "CfgVehicles" >> typeOf _x >> "displayName");
		if (!isNull DZE_myVehicle && {local DZE_myVehicle} && {alive DZE_myVehicle} && {DZE_myVehicle == _x}) then {
			_control lbSetColor [(lbSize _control)-1,[0, 1, 0, 1]];
		};
	} count rv_vehicleList;
	_control lbSetCurSel 0;

	waitUntil {!dialog};

} else {
	rv_selected = rv_vehicleList select 0;
	rv_isOk = true;
};

if (!rv_isOk) exitWith {call _exit;};

if (!_vehicleFound) exitWith {systemChat "Unable to find a valid vehicle for this key."; call _exit;};

_vehicleType = typeOf rv_selected;
_displayName = getText(configFile >> "CfgVehicles" >> _vehicleType >> "displayName");

if (!alive rv_selected) exitWith {systemChat "The vehicle for this key has been destroyed."; call _exit;};
if (_checkDistance && {(player distance rv_selected) >= _distance}) exitWith {format ["The remote is out of range for your %1.",_displayName] call dayz_rollingMessages; call _exit;};

if (_option == 1) then {
	_group = units group player;

	systemChat format ["Ejecting all players not in your group from: %1",_displayName];
	{
		if !(_x in _group) then {
			_x action ["eject",rv_selected];
			systemChat format ["Ejecting %1, they are NOT in your group.",name _x];
		};
	} forEach (crew rv_selected);
};

if (_option == 2) then {
	systemChat format ["Toggling engine %1 in: %2",if (isEngineOn rv_selected) then {"off"} else {"on"},_displayName];
	if (isEngineOn rv_selected) then {
		if (rv_selected isKindOf "Helicopter") then { // This is needed because dayz_engineSwitch won't turn off the engine for a helicopter.
			_fuel = fuel rv_selected;
			rv_selected setFuel 0;
			player action ["engineOff",rv_selected];
			uiSleep 4; 
			rv_selected setFuel _fuel;
		} else {
			[rv_selected,false] call dayz_engineSwitch;
		};
	} else {
		[rv_selected,true] call dayz_engineSwitch
	};
};

if (_option == 3) then {
	systemChat format ["Unlocking: %1",_displayName];
	PVDZE_veh_Lock = [rv_selected,false];
	_time = diag_tickTime;

	if (local rv_selected) then {
		PVDZE_veh_Lock call local_lockUnlock;
	} else {
		publicVariable "PVDZE_veh_Lock";
		//Wait for lock status to update over network (can take up to a few seconds)
		waitUntil {uiSleep 0.1;(!locked rv_selected or (diag_tickTime - _time > 4))};
	};
};

if (_option == 4) then {
	systemChat format ["Locking: %1",_displayName];
	PVDZE_veh_Lock = [rv_selected,true];
	_time = diag_tickTime;

	if (local rv_selected) then {
		PVDZE_veh_Lock call local_lockUnlock;
	} else {
		publicVariable "PVDZE_veh_Lock";
		//Wait for lock status to update over network (can take up to a few seconds)
		waitUntil {uiSleep 0.1;(locked rv_selected or (diag_tickTime - _time > 4))};
	};
};

if (_option == 5) then {
	if !(rv_selected getVariable["vehicleLights",false]) then {
		player action ["lightOn", rv_selected];
		systemChat format ["Toggled lights on: %1", _vehicleType];
		rv_selected setVariable ["vehicleLights",true,true];
	} else {
		player action ["lightOff", rv_selected];
		systemChat format ["Toggled lights off: %1", _vehicleType];
		rv_selected setVariable ["vehicleLights",false,true];
	};
};

call _exit;