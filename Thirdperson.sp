#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <multicolors>
#include <clientprefs>
#include <tf2>

bool g_bThirdPerson[MAXPLAYERS + 1];
Handle g_hCookieTP;

#define PLUGIN_NAME        "Thirdperson Toggle"
#define PLUGIN_AUTHOR      "Kometa"
#define PLUGIN_VERSION     "1.0.0"
#define PLUGIN_URL         "https://github.com/HimeKometa"

public Plugin myinfo =
{
	name        = PLUGIN_NAME,
	author      = PLUGIN_AUTHOR,
	description = PLUGIN_NAME,
	version     = PLUGIN_VERSION,
	url         = PLUGIN_URL
};

public void OnPluginStart()
{
    RegConsoleCmd("sm_tp", Command_TP);
    RegConsoleCmd("sm_thirdperson", Command_TP);
    RegConsoleCmd("sm_fp", Command_FP);
    RegConsoleCmd("sm_firstperson", Command_FP);
    RegConsoleCmd("say", Command_Say);
    RegConsoleCmd("say_team", Command_Say);

    HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);

    LoadTranslations("thirdperson.phrases");

    g_hCookieTP = RegClientCookie("tp_toggle", "Thirdperson toggle state", CookieAccess_Protected);

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i)) 
        {
            LoadThirdPersonState(i);
        }
    }
}

public void OnClientPutInServer(int client)
{
    g_bThirdPerson[client] = false;
    SDKHook(client, SDKHook_PostThink, OnPostThink); 

    LoadThirdPersonState(client);
}

public void LoadThirdPersonState(int client)
{
    char sValue[4];
    
    GetClientCookie(client, g_hCookieTP, sValue, sizeof(sValue));

    if (StrEqual(sValue, "") || !StrEqual(sValue, "1"))
    {
        g_bThirdPerson[client] = false;  
    }
    else
    {
        g_bThirdPerson[client] = true;  
    }

    ApplyView(client);
}

public void OnClientPostAdminCheck(int client)
{
    ApplyView(client);
}

public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    if (client > 0 && IsClientInGame(client) && g_bThirdPerson[client])
    {
        ApplyView(client);
    }
}

public Action ApplyViewTimer(Handle timer, any userid)
{
    int client = GetClientOfUserId(userid);
    if (client > 0 && IsClientInGame(client))
    {
        ApplyView(client);
    }
    return Plugin_Stop;
}

public Action Command_TP(int client, int args)
{
    if (!IsClientInGame(client)) return Plugin_Handled;

    g_bThirdPerson[client] = true;
    ApplyView(client);

    SetClientCookie(client, g_hCookieTP, "1");

    CPrintToChat(client, "%t", "ThirdpersonEnabled");
    return Plugin_Handled;
}

public Action Command_FP(int client, int args)
{
    if (!IsClientInGame(client)) return Plugin_Handled;

    g_bThirdPerson[client] = false;
    ApplyView(client);

    SetClientCookie(client, g_hCookieTP, "0");

    CPrintToChat(client, "%t", "FirstpersonEnabled");
    return Plugin_Handled;
}

public Action Command_Say(int client, int args)
{
    if (!IsClientInGame(client) || IsFakeClient(client)) return Plugin_Continue;

    char msg[64];
    GetCmdArgString(msg, sizeof(msg));
    TrimString(msg);

    if (StrEqual(msg, "!tp", false)) return Command_TP(client, 0);
    if (StrEqual(msg, "!fp", false)) return Command_FP(client, 0);

    return Plugin_Continue;
}

void ApplyView(int client)
{
    if (!IsClientInGame(client)) return;

    SetVariantInt(g_bThirdPerson[client] ? 1 : 0);
    AcceptEntityInput(client, "SetForcedTauntCam");
    SetEntProp(client, Prop_Send, "m_bDrawViewmodel", g_bThirdPerson[client] ? 0 : 1);
}

public void OnPostThink(int client)
{
    if (!IsClientInGame(client)) return;

    if (g_bThirdPerson[client])
    {
        ApplyView(client);
    }
}
