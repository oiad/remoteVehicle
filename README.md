# [EPOCH 1.0.7] Remote Vehicle Locking/Engine Status and kick out non group members.

* Discussion URL: https://epochmod.com/forum/topic/44104-release-remote-vehicle-lockingengineeject-script/
	
* Tested as working on a blank Epoch 1.0.7
* Uses clickActions as a dependancy

# REPORTING ERRORS/PROBLEMS

1. Please, if you report issues can you please attach (on pastebin or similar) your CLIENT rpt log file as this helps find out the errors very quickly. To find this logfile:

	```sqf
	C:\users\<YOUR WINDOWS USERNAME>\AppData\Local\Arma 2 OA\ArmA2OA.RPT
	```

# Index:

* [Mission folder install](https://github.com/oiad/remoteVehicle#mission-folder-install)
* [BattlEye filter install](https://github.com/oiad/remoteVehicle#battleye-filter-install)
* [Old Releases](https://github.com/oiad/remoteVehicle#old-releases)

**[>> Download <<](https://github.com/oiad/remoteVehicle/archive/master.zip)**

# Install:

* This install basically assumes you have a custom compiles.sqf.

** If not, visit this repo and follow the steps there **
https://github.com/AirwavesMan/custom-epoch-functions

* If you have not installed the Click Actions visit this  
https://github.com/AirwavesMan/epoch-right-click-actions


# Mission folder install:

1. Move the <code>scripts</code> folder and files <code>scripts\remoteVehicle</code> to your mission folder root preserving directory structure.
	
	```sqf
	scripts\remoteVehicle	
	```
	
2. Open your compiles.sqf and search for:

	```sqf
	if (!isDedicated) then {
	```
	
	And add this inside the square brackets so it looks like this:
	
	```sqf
	if (!isDedicated) then {
		remoteVehicle = compile preprocessFileLineNumbers "scripts\remoteVehicle\remoteVehicle.sqf";
	};	
	```

3. Edit your scripts\clickActions\config.sqf and add this line to your DZE_CLICK_ACTIONS array:

	```sqf
	["ItemKey",localize "STR_CL_RV_CA_EJECT","spawn remoteVehicle;","true",1],
	["ItemKey",localize "STR_CL_RV_CA_ENGINE","spawn remoteVehicle;","true",2],
	["ItemKey",localize "STR_CL_RV_CA_UNLOCK","spawn remoteVehicle;","true",3],
	["ItemKey",localize "STR_CL_RV_CA_LOCK","spawn remoteVehicle;","true",4],
	["ItemKey",localize "STR_CL_RV_CA_LIGHTS","spawn remoteVehicle;","true",5]
	```

	For example:

	```sqf
	DZE_CLICK_ACTIONS = [
		["ItemGPS","Scan Nearby","if(isNil 'DZE_CLICK_ACTIONS_GPS_RANGE') then {DZE_CLICK_ACTIONS_GPS_RANGE = 1500;};DZE_CLICK_ACTIONS_ZOMBIE_COUNT = count ((position player) nearEntities ['zZombie_Base',DZE_CLICK_ACTIONS_GPS_RANGE]); DZE_CLICK_ACTIONS_MAN_COUNT = count ((position player) nearEntities ['CAManBase',DZE_CLICK_ACTIONS_GPS_RANGE]); format['Within %1 Meters: %2 AI/players, %3 zombies, %4 vehicles',DZE_CLICK_ACTIONS_GPS_RANGE,DZE_CLICK_ACTIONS_MAN_COUNT - DZE_CLICK_ACTIONS_ZOMBIE_COUNT,count ((position player) nearEntities ['zZombie_Base',DZE_CLICK_ACTIONS_GPS_RANGE]),count ((position player) nearEntities ['allVehicles',DZE_CLICK_ACTIONS_GPS_RANGE]) - DZE_CLICK_ACTIONS_MAN_COUNT] call dayz_rollingMessages;","true"],
		["ItemGPS","Range Up"   ,"if(isNil 'DZE_CLICK_ACTIONS_GPS_RANGE') then {DZE_CLICK_ACTIONS_GPS_RANGE = 1500;};DZE_CLICK_ACTIONS_GPS_RANGE = (DZE_CLICK_ACTIONS_GPS_RANGE + 100) min 2500; format['GPS RANGE: %1',DZE_CLICK_ACTIONS_GPS_RANGE] call dayz_rollingMessages;","true"],
		["ItemGPS","Range Down" ,"if(isNil 'DZE_CLICK_ACTIONS_GPS_RANGE') then {DZE_CLICK_ACTIONS_GPS_RANGE = 1500;};DZE_CLICK_ACTIONS_GPS_RANGE = (DZE_CLICK_ACTIONS_GPS_RANGE - 100) max 1000; format['GPS RANGE: %1',DZE_CLICK_ACTIONS_GPS_RANGE] call dayz_rollingMessages;","true"],
		["ItemKey",localize "STR_CL_RV_CA_EJECT","spawn remoteVehicle;","true",1],
		["ItemKey",localize "STR_CL_RV_CA_ENGINE","spawn remoteVehicle;","true",2],
		["ItemKey",localize "STR_CL_RV_CA_UNLOCK","spawn remoteVehicle;","true",3],
		["ItemKey",localize "STR_CL_RV_CA_LOCK","spawn remoteVehicle;","true",4],
		["ItemKey",localize "STR_CL_RV_CA_LIGHTS","spawn remoteVehicle;","true",5]
	];
	```

	If it's the last item in the array, then you must make sure you don't have a <code>,</code> at the end.

4. In <code>mission\description.ext</code> Add the following line at the end of the file:

	```sqf
	#include "scripts\remoteVehicle\remoteVehicle.hpp"
	```

# BattlEye filter install:

1. In your config\<yourServerName>\Battleye\scripts.txt around line 22: <code>1 compile</code> add this to the end of it:

	```sqf
	!="ay\",\"_exit\"];\n\nif (isNil \"rv_init\") then {\nrv_vehicleInfo = compile preprocessFileLineNumbers \"scripts\\remoteVehicle\\vehicleInfo"
	```

	So it will then look like this for example:

	```sqf
	1 compile !="ay\",\"_exit\"];\n\nif (isNil \"rv_init\") then {\nrv_vehicleInfo = compile preprocessFileLineNumbers \"scripts\\remoteVehicle\\vehicleInfo"
	```

2. In your config\<yourServerName>\Battleye\scripts.txt around line 24: <code>5 createDialog</code> add this to the end of it:

	```sqf
	!=";\n\nif (count rv_vehicleList > 1) then {\nrv_isOk = false;\n\ncreateDialog \"remoteVehicle\";\n\n_display = uiNamespace getVariable[\"rv_"
	```

	So it will then look like this for example:

	```sqf
	5 createDialog <CUT> !=";\n\nif (count rv_vehicleList > 1) then {\nrv_isOk = false;\n\ncreateDialog \"remoteVehicle\";\n\n_display = uiNamespace getVariable[\"rv_"
	```
	
3. In your config\<yourServerName>\Battleye\scripts.txt around line 50: <code>5 lbSet</code> add this to the end of it:

	```sqf
	!="ive DZE_myVehicle} && {DZE_myVehicle == _x}) then {\n_control lbSetColor [(lbSize _control)-1,[0, 1, 0, 1]];\n};\n} count rv_vehicl"
	```

	So it will then look like this for example:

	```sqf
	5 lbSet <CUT> !="ive DZE_myVehicle} && {DZE_myVehicle == _x}) then {\n_control lbSetColor [(lbSize _control)-1,[0, 1, 0, 1]];\n};\n} count rv_vehicl"
	```	
	
4. In your config\<yourServerName>\Battleye\scripts.txt around line 85: <code>5 title</code> add this to the end of it:

	```sqf
	!="play displayCtrl 8801 ctrlSetText(format[localize \"STR_CL_RV_TITLE\",_keyDisplay]);\n\n_control = ((findDisplay 8800) displayCtrl 8"
	```

	So it will then look like this for example:

	```sqf
	5 title <CUT> !="play displayCtrl 8801 ctrlSetText(format[localize \"STR_CL_RV_TITLE\",_keyDisplay]);\n\n_control = ((findDisplay 8800) displayCtrl 8"
	```	

# Old Releases:	

**** *Epoch 1.0.6.2* ****
**[>> Download <<](https://github.com/oiad/remoteVehicle/archive/refs/tags/Epoch_1.0.6.2.zip)**



