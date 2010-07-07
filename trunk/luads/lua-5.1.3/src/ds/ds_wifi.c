/*
*
*/

#include <stdlib.h>
#include <stdio.h>

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

//static int wifi_status(lua_State *L){
//	lua_pushnumber(L, Wifi_AssocStatus());
//	return 1;
//}

static int wifi_disconnect(lua_State *L){
	Wifi_DisconnectAP();
	return 0;
}

static int wifi_getLocalIP(lua_State *L){
	lua_pushnumber(L, Wifi_GetIP());
	return 1;
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
	char * buffer = (char *)luaL_checkstring(L, 2);
	assert(L, my_socket >= 0, "Invalid socket");
	assert(L, buffer != NULL, "Buffer can't be null");
	send(my_socket, buffer, strlen(buffer), 0);
	return 0;
}

static int wifi_receive(lua_State *L){
	int my_socket = (int)luaL_checknumber(L, 1);
	int length = (int)luaL_checknumber(L, 2);
	assert(L, my_socket >= 0, "Invalid socket");
	assert(L, length > 0, "Length must be > 0");
	char buffer[length];
	int recv_len = recv(my_socket, buffer, length, 0);
	if(recv_len > 0){
		lua_pushlstring(L, buffer, recv_len);
		return 1;
	}else{
		return 0;
	}
}

static const luaL_Reg wifilib[] = {
	{"connectWFC", wifi_connectWFC},
	//{"status", wifi_status},
	{"disconnect", wifi_disconnect},
	{"getLocalIP", wifi_getLocalIP},
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
