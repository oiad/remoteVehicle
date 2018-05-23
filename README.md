# [EPOCH 1.0.6.1] Remote Vehicle Locking/Engine Status and kick out non group members.

* Discussion URL: https://epochmod.com/forum/topic/44104-release-remote-vehicle-lockingengineeject-script/
	
* Tested as working on a blank Epoch 1.0.6.1
* Uses clickActions as a dependancy

# REPORTING ERRORS/PROBLEMS

1. Please, if you report issues can you please attach (on pastebin or similar) your CLIENT rpt log file as this helps find out the errors very quickly. To find this logfile:

	```sqf
	C:\users\<YOUR WINDOWS USERNAME>\AppData\Local\Arma 2 OA\ArmA2OA.RPT
	```

# Install:

* This uses Click Actions by Mudzereli as a dependancy: https://github.com/mudzereli/DayZEpochDeployableBike/tree/master/overwrites/click_actions

**[>> Download <<](https://github.com/oiad/remoteVehicle/archive/master.zip)**

# Mission folder install:

1. If you don't have a custom compiles file do the following:
	1. In mission\init.sqf find: <code>call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";</code> and add directly below:

	```sqf
	call compile preprocessFileLineNumbers "dayz_code\init\compiles.sqf";
	```
	2. Copy the <code>dayz_code\init</code> folder structure to your mission folder root.

2. Copy the supplied <code>ui_selectSlot.sqf</code> to <code>dayz_code\compile</code>.

3. In your clickActions <code>scripts\clickActions\config.sqf</code> find this line:
	```sqf
	["ItemMap",localize "STR_CL_LV_LOCATE_VEHICLES","execVM 'scripts\locateVehicle.sqf';","true"]
	```
	
	Add the following code block after it:

	```sqf
	["ItemKey",localize "STR_CL_RV_CA_EJECT","spawn remoteVehicle;","true",1],
	["ItemKey",localize "STR_CL_RV_CA_ENGINE","spawn remoteVehicle;","true",2],
	["ItemKey",localize "STR_CL_RV_CA_UNLOCK","spawn remoteVehicle;","true",3],
	["ItemKey",localize "STR_CL_RV_CA_LOCK","spawn remoteVehicle;","true",4],
	["ItemKey",localize "STR_CL_RV_CA_LIGHTS","spawn remoteVehicle;","true",5]
	```
	
	Make sure to put a , after the locateVehicle.sqf line (the line you were finding in section 3)
	
4. In your <code>mission\dayz_code\init\compiles.sqf</code> find this line:
	```sqf
	fnc_usec_selfActions = compile preprocessFileLineNumbers "dayz_code\compile\fn_selfActions.sqf";
	```
	Add the following lines after it:
	```sqf
	player_selectSlot = compile preprocessFileLineNumbers "dayz_code\compile\ui_selectSlot.sqf";
	remoteVehicle = compile preprocessFileLineNumbers "scripts\remoteVehicle\remoteVehicle.sqf";
	```

5. In <code>mission\description.ext</code> Add the following line at the end of the file:
	```sqf
	#include "scripts\remoteVehicle\remoteVehicle.hpp"
	```

6. Download the <code>stringTable.xml</code> file linked below from the [Community Localization GitHub](https://github.com/oiad/communityLocalizations) and copy it to your mission folder, it is a community based localization file and contains translations for major community mods including this one.

**[>> Download stringTable.xml <<](https://github.com/oiad/communityLocalizations/blob/master/stringTable.xml)**

# Battleye filter install:
1. In your config\<yourServerName>\Battleye\scripts.txt around line 12: <code>5 createDialog</code> add this to the end of it:

	```sqf
	!"createDialog \"remoteVehicle\";"
	```
	
	So it will then look like this for example:
	```sqf
	5 createDialog <CUT> !"createDialog \"remoteVehicle\";"
	```
