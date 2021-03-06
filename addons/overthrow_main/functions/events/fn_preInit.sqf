diag_log "Overthrow: Pre-Init";

if(isServer) then {
    private _center = createCenter sideLogic;
    private _group = createGroup _center;

    server = _group createUnit ["LOGIC",[0,0,0] , [], 0, ""];
    cost = _group createUnit ["LOGIC",[1,0,0] , [], 0, ""];
    warehouse = _group createUnit ["LOGIC",[2,0,0] , [], 0, ""];
    spawner = _group createUnit ["LOGIC",[3,0,0] , [], 0, ""];
    templates = _group createUnit ["LOGIC",[4,0,0] , [], 0, ""];

    publicVariable "server";
    publicVariable "cost";
    publicVariable "warehouse";
    publicVariable "spawner";
    publicVariable "templates";
};

//VCOM AI, huge credits to Genesis, without VCOM this campaign would be so much less
[] call OT_fnc_initVCOMAI;

[] execVM "\ot\functions\geography\SHK_pos\shk_pos_init.sqf";

if(isServer) then {
    diag_log "Overthrow: Server Pre-Init";

    server setVariable ["StartupType","",true];
    call OT_fnc_initVirtualization;
};
