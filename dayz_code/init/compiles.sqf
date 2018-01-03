if (isServer) then {
	diag_log "Loading custom server compiles";
};

if (!isDedicated) then {
	diag_log "Loading custom client compiles";

	player_selectSlot = compile preprocessFileLineNumbers "dayz_code\compile\ui_selectSlot.sqf";
	remoteVehicle = compile preprocessFileLineNumbers "scripts\remoteVehicle\remoteVehicle.sqf";
};
