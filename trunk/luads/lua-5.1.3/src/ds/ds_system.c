/*
*
*/

#include <stdlib.h>
#include <stdio.h>
#include <malloc.h>

#define ds_system_c
#define LUA_LIB

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include <fat.h>
#include <sys/stat.h>
#include <sys/dir.h>
#include <unistd.h>
#include <dirent.h>
#include <string.h>
#include <time.h>
#include <ulib/ulib.h>

#include "vars.h"

#define TIME_YEAR 0
#define TIME_MONTH 1
#define TIME_DAY 2
#define TIME_HOUR 3
#define TIME_MINUTE 4
#define TIME_SECOND 5
#define TIME_WEEKDAY 6
#define TIME_YEARDAY 7

static int system_currentVramUsed(lua_State *L) {
	lua_pushnumber(L, (unsigned int) ulGetTexVramUsedMemory());
	return 1;
}

static int system_currentVramFree(lua_State *L) {
	lua_pushnumber(L, (unsigned int) ulGetTexVramAvailMemory());
	return 1;
}

static int system_currentPalUsed(lua_State *L) {
	lua_pushnumber(L, (unsigned int) ulGetTexPalUsedMemory());
	return 1;
}

static int system_currentPalFree(lua_State *L) {
	lua_pushnumber(L, (unsigned int) ulGetTexPalAvailMemory());
	return 1;
}

static int system_currentDirectory(lua_State *L) {
	char *path;
    char rep[256];
    path = getcwd(rep, 255);
	lua_pushstring(L, rep);
	return 1;
}

static int system_changeDirectory(lua_State *L) {
	char * dir = (char *)luaL_checkstring(L, 1);
	chdir(dir);
	return 0;
}

static int system_remove(lua_State *L) {
	char * dir = (char *)luaL_checkstring(L, 1);
	remove(dir);
	return 0;
}

static int system_rename(lua_State *L) {
	char * dir1 = (char *)luaL_checkstring(L, 1);
	char * dir2 = (char *)luaL_checkstring(L, 2);
	rename(dir1, dir2);
	return 0;
}

static int system_makeDirectory(lua_State *L) {
	char * dir = (char *)luaL_checkstring(L, 1);
	mkdir(dir, 777);
	return 0;
}

int entcmp(const void *ent1, const void *ent2) {
    struct dirent *ent12 = (struct dirent*)ent1;
    struct dirent *ent22 = (struct dirent*)ent2;
    return strcmp(ent12->d_name, ent22->d_name);
}

static int system_listDirectory(lua_State *L) {
    char* dirName = (char*)luaL_checkstring(L, 1);
    assert(L, dirName != NULL, "You must specifiy a directory name!");
    DIR* dir = opendir(dirName);
    
    struct dirent *curEnt = NULL;
    struct stat *statBuf = NULL;
    
    int i;
    lua_newtable(L);
    for (i = 0; (curEnt = readdir(dir)) != NULL; i++) {
        lua_newtable(L);
        lua_pushstring(L, curEnt->d_name);
        lua_setfield(L, -2, "name");
        stat(curEnt->d_name, statBuf);
        lua_pushboolean(L, S_ISDIR(statBuf->st_mode));
        lua_setfield(L, -2, "isDir");
        lua_pushnumber(L, statBuf->st_size);
        lua_setfield(L, -2, "size");
        lua_pushnumber(L, i++);
        lua_pushvalue(L, -2);
        lua_settable(L, -4);
        lua_pop(L, 1);
    }
    
    return 1;
}

static int system_getCurrentTime(lua_State *L) {
	int type = (int)luaL_checknumber(L, 1);
	time_t unixTime = time(0);
	struct tm* timeStruct = localtime((const time_t *)&unixTime);
	int ret = 0;
	switch(type){
		case TIME_YEAR:
			ret = timeStruct->tm_year + 1900;
		break;
		case TIME_MONTH:
			ret = timeStruct->tm_mon + 1;
		break;
		case TIME_DAY:
			ret = timeStruct->tm_mday;
		break;
		case TIME_WEEKDAY:
			ret = timeStruct->tm_wday;
		break;
		case TIME_YEARDAY:
			ret = timeStruct->tm_yday;
		break;
		case TIME_HOUR:
			ret = timeStruct->tm_hour;
		break;
		case TIME_MINUTE:
			ret = timeStruct->tm_min;
		break;
		case TIME_SECOND:
			ret = timeStruct->tm_sec;
		break;
		default:
			luaL_error(L, "Bad parameter");
		break;
	}
	timeStruct = NULL;
	lua_pushnumber(L, ret);
	return 1;
}

static const luaL_Reg systemlib[] = {
	{"currentDirectory", system_currentDirectory},
	{"changeDirectory", system_changeDirectory},
	{"remove", system_remove},
	{"rename", system_rename},
	{"makeDirectory", system_makeDirectory},
	{"listDirectory", system_listDirectory},
	{"getCurrentTime", system_getCurrentTime},
	{"currentVramUsed", system_currentVramUsed},
	{"currentVramFree", system_currentVramFree},
	{"currentPalUsed", system_currentPalUsed},
	{"currentPalFree", system_currentPalFree},
	{NULL, NULL}
};

/*
** Open infos library
*/
LUALIB_API int luaopen_system (lua_State *L) {
    luaL_register(L, LUA_SYSTEMLIBNAME, systemlib);
    return 1;
}
