/*
*
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define ds_wifi_c
#define LUA_LIB

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include <nds.h>
#include <ulib/ulib.h>

#include <dswifi9.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

#include "vars.h"


static int wifi_connectWFC(lua_State *L){
	lua_pushboolean(L, Wifi_InitDefault(WFC_CONNECT));
	return 1;
}

static int wifi_initDefault(lua_State *L){
	lua_pushboolean(L, Wifi_InitDefault(INIT_ONLY));
	return 1;
}

static int wifi_scanAP(lua_State *L){
	Wifi_ScanMode();
	lua_pushnumber(L, Wifi_GetNumAP());
	return 1;
}

static int wifi_getAP(lua_State *L){
	int numAP = (int)luaL_checknumber(L,1);
	assert(L, numAP>-1 && numAP<Wifi_GetNumAP(), "Vous demandez des infos sur une AP inexistante.");
	char *reponse = "";
	char protection[] ="NONE";
	Wifi_AccessPoint ap;
	Wifi_GetAPData(numAP, &ap);
	ap.ssid[(int)ap.ssid_len]=0;
	if( ap.flags & WFLAG_APDATA_WEP ) sprintf(protection,"WEP");
	else if (ap.flags & WFLAG_APDATA_WPA) sprintf(protection,"WPA");
	sprintf(reponse,"%s#%02x%02x%02x%02x%02x%02x#%02x:%02x:%02x:%02x:%02x:%02x#%d#%d#%d#%s#%s#%s#\n", 
		ap.ssid,
		ap.bssid[0],ap.bssid[1],ap.bssid[2],ap.bssid[3],ap.bssid[4],ap.bssid[5],
		ap.macaddr[0],ap.macaddr[1],ap.macaddr[2],ap.macaddr[3],ap.macaddr[4],ap.macaddr[5],
		ap.channel,
		ap.rssi,
		ap.maxrate,
		protection,
		ap.flags & WFLAG_APDATA_ADHOC ? "1":"0",
		ap.flags & WFLAG_APDATA_ACTIVE ? "1":"0");
	lua_pushstring(L, reponse);
	return 1;
}

static int wifi_connectAP(lua_State *L){
	int numAP = (int)luaL_checknumber(L,1);
	int wepmod = 0;
	int numkey = (int)luaL_checknumber(L,2);
	unsigned char *key = (unsigned char *)luaL_checkstring(L,3);
	Wifi_AccessPoint ap;
	char wepkey[30];
	int i, j;
	int rep;
	i=0;
	Wifi_GetAPData(numAP, &ap);
	if(strlen((char *)key) < 2) rep = Wifi_ConnectAP(&ap,0,0,0);
	else{
		if(strlen((char *)key) == 10) wepmod = 1;
		else wepmod = 2;
		while(*key) {
			j=0;
			if(*key>='0' && *key<='9') j=*key-'0';
			if(*key>='A' && *key<='F') j=*key-'A'+10;
			if(i&1) wepkey[i/2] = (wepkey[i/2]&0xF0)|j; 
			else wepkey[i/2] = (wepkey[i/2]&0xF)|(j<<4);
			i++;
			key++;
		}
		wepkey[i/2] = 0;
		rep = Wifi_ConnectAP(&ap,wepmod,numkey,(u8 *)wepkey);
	}
	lua_pushnumber(L,rep);
	return 1;
}

static int wifi_status(lua_State *L){
	int status = Wifi_AssocStatus();
	lua_pushstring(L, ASSOCSTATUS_STRINGS[status]);
	return 1;
}

static int wifi_reset(lua_State *L){
	Wifi_DisableWifi();
	Wifi_EnableWifi();
	return 0;
}

static int wifi_stop(lua_State *L){
	Wifi_DisableWifi();
	return 0;
}

static int wifi_disconnect(lua_State *L){
	Wifi_DisconnectAP();
	return 0;
}

static int wifi_getLocalIP(lua_State *L){
	struct in_addr ip;
	ip.s_addr = Wifi_GetIP();
	lua_pushstring(L, inet_ntoa(ip));
	return 1;
}

static int wifi_getLocalConf(lua_State *L){
	int choix = (int)luaL_checknumber(L,1);
	assert(L, choix>=1 && choix <= 6, "Arg1 must be between 1 and 6");
	struct in_addr ip;
	struct in_addr gate;
	struct in_addr submask;
	struct in_addr dns1;
	struct in_addr dns2;
	int num;
	unsigned char * buffer;
	ip = Wifi_GetIPInfo(&gate, &submask, &dns1, &dns2);
	num = Wifi_GetData(WIFIGETDATA_MACADDRESS, 20, buffer);
	// Choix = 1:ip  2:gateway  3:subnetMask  4:DNS1  5:DNS2  6:MACADRR
	switch(choix){
		case 1: lua_pushstring(L, inet_ntoa(ip));
			break;
		case 2: lua_pushstring(L, inet_ntoa(gate));
			break;
		case 3: lua_pushstring(L, inet_ntoa(submask));
			break;
		case 4: lua_pushstring(L, inet_ntoa(dns1));
			break;
		case 5: lua_pushstring(L, inet_ntoa(dns2));
			break;
		case 6: lua_pushstring(L, (char *)buffer);
			break;
	}
	return 1;
}

static int wifi_useDHCP(lua_State *L){
	Wifi_SetIP(0,0,0,0,0);
	return 0;
}

static int wifi_autoConnectWFC(lua_State *L){
	Wifi_AutoConnect();
	return 0;
}

static int wifi_setLocalIP(lua_State *L){
	char * ip = (char *)luaL_checkstring(L,1);
	char * gateway = (char *)luaL_checkstring(L,2);
	char * subnetmask = (char *)luaL_checkstring(L,3);
	char * dns1 = (char *)luaL_checkstring(L,4);
	char * dns2 = (char *)luaL_checkstring(L,5);
	struct in_addr iph, gate, mask, DNS1, DNS2;
	assert(L, ip != NULL, "IP can't be null.");
	assert(L, gateway != NULL, "Gateway can't be null"); 
	if(subnetmask == NULL) strcpy(subnetmask,"255.255.255.0");
	if(dns1 == NULL) strcpy(dns1,"0.0.0.0");
	if(dns2 == NULL) strcpy(dns2,"0.0.0.0");
	inet_aton(ip, &iph);
	inet_aton(gateway, &gate);
	inet_aton(subnetmask, &mask);
	inet_aton(dns1, &DNS1);
	inet_aton(dns2, &DNS2);
	Wifi_SetIP(iph.s_addr,gate.s_addr,mask.s_addr,DNS1.s_addr,DNS2.s_addr);
	return 0;
}

static int wifi_createTCPSocket(lua_State *L){
	char * url = (char *)luaL_checkstring(L, 1);
	int port = (int)luaL_checknumber(L, 2);
	assert(L, url != NULL, "Url can't be null");
	assert(L, port >= 0 && port <= 65565, "Port number must be betweem 0 and 65565");
	struct hostent * myhost = gethostbyname(url);
	int my_socket;
	my_socket = socket(AF_INET, SOCK_STREAM, 0);
	assert(L, my_socket >= 0, "Impossible to create the socket");
	struct sockaddr_in sain;
	sain.sin_family = AF_INET;
	sain.sin_port = htons(port);
	sain.sin_addr.s_addr= *((unsigned long *)(myhost->h_addr_list[0]));
	connect(my_socket,(struct sockaddr *)&sain, sizeof(sain));
	lua_pushnumber(L, my_socket);
	return 1;
}

static int wifi_createUDPSocket(lua_State *L){
	char * url = (char *)luaL_checkstring(L, 1);
	int port = (int)luaL_checknumber(L, 2);
	assert(L, url != NULL, "Url can't be null");
	assert(L, port >= 0 && port <= 65565, "Port number must be betweem 0 and 65565");
	struct hostent * myhost = gethostbyname(url);
	int my_socket;
	my_socket = socket(AF_INET, SOCK_DGRAM, 0);
	assert(L, my_socket >= 0, "Impossible to create the socket");
	struct sockaddr_in sain;
	sain.sin_family = AF_INET;
	sain.sin_port = htons(port);
	sain.sin_addr.s_addr= *((unsigned long *)(myhost->h_addr_list[0]));
	connect(my_socket,(struct sockaddr *)&sain, sizeof(sain));
	lua_pushnumber(L, my_socket);
	return 1;
}

static int wifi_closeSocket(lua_State *L){
	int my_socket = (int)luaL_checknumber(L, 1);
	assert(L, my_socket >= 0, "Invalid socket");
	shutdown(my_socket, 0);
	closesocket(my_socket);
	return 0;
}

static int wifi_send(lua_State *L){
	int my_socket = (int)luaL_checknumber(L, 1);
	unsigned int length;
	char * buffer = (char *)luaL_checklstring(L, 2, &length);
	assert(L, my_socket >= 0, "Invalid socket");
	assert(L, buffer != NULL, "Buffer can't be null");
	send(my_socket, buffer, length, 0);
	return 0;
}

static int wifi_waitData(lua_State *L){
	unsigned long available;
	int my_socket = (int)luaL_checknumber(L, 1);
	assert(L, my_socket >= 0, "Invalid socket");
	ioctl(my_socket, FIONREAD, &available);
	lua_pushnumber(L, available);
	return 1;
}

static int wifi_receive(lua_State *L){
	int my_socket = (int)luaL_checknumber(L, 1);
	int length = (int)luaL_checknumber(L, 2);
	assert(L, my_socket >= 0, "Invalid socket");
	assert(L, length > 0, "Length must be > 0");
	char buffer[length];
	int recv_len = recv(my_socket, buffer, length, 0);
	if(recv_len > 0){
		lua_pushlstring(L, buffer,recv_len);
		return 1;
	}else{
		return 0;
	}	
}

static const luaL_Reg wifilib[] = {
	{"initDefault", wifi_initDefault},
	{"reset", wifi_reset},
	{"connectWFC", wifi_connectWFC},
	{"autoConnectWFC", wifi_autoConnectWFC},
	{"getLocalConf", wifi_getLocalConf},
	{"waitData", wifi_waitData},
	{"useDHCP", wifi_useDHCP},
	{"scanAP", wifi_scanAP},
	{"getAP", wifi_getAP},
	{"stop", wifi_stop},
	{"connectAP", wifi_connectAP},
	{"status", wifi_status},
	{"disconnect", wifi_disconnect},
	{"getLocalIP", wifi_getLocalIP},
	{"setLocalIP", wifi_setLocalIP},
	{"createTCPSocket", wifi_createTCPSocket},
	{"createUDPSocket", wifi_createUDPSocket},
	{"closeSocket", wifi_closeSocket},
	{"send", wifi_send},
	{"receive", wifi_receive},
	{NULL, NULL}
};

/*
** Open infos library
*/
LUALIB_API int luaopen_wifi (lua_State *L) {
  luaL_register(L, LUA_WIFILIBNAME, wifilib);
  return 1;
}





