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

#define TIME_YEAR 0
#define TIME_MONTH 1
#define TIME_DAY 2
#define TIME_HOUR 3
#define TIME_MINUTE 4
#define TIME_SECOND 5
#define TIME_WEEKDAY 6
#define TIME_YEARDAY 7


int dirListed;
char * dirname;
//DIR_ITER* dir;
DIR *pdir;
struct dirent *pent;
struct stat statbuf;

//cette fonction retourne un chiffre bizard
static int system_currentVramUsed(lua_State *L){
	lua_pushnumber(L, (unsigned int) ulGetTexVramUsedMemory());
	return 1;
}

static int system_currentVramFree(lua_State *L){
	lua_pushnumber(L, (unsigned int) ulGetTexVramAvailMemory());
	return 1;
}

//cette fonction retourne aussi un chiffre bizard
static int system_currentPalUsed(lua_State *L){
	lua_pushnumber(L, (unsigned int) ulGetTexPalUsedMemory());
	return 1;
}

static int system_currentPalFree(lua_State *L){
	lua_pushnumber(L, (unsigned int) ulGetTexPalAvailMemory());
	return 1;
}

static int system_currentDirectory(lua_State *L){
	char *path;
    char rep[256];
    path = getcwd(rep, 255);
	lua_pushstring(L, rep);
	return 1;
}

static int system_changeCurrentDirectory(lua_State *L){
	char * dir = (char *)luaL_checkstring(L, 1);
	chdir(dir);
	return 0;
}

static int system_remove(lua_State *L){
	char * dir = (char *)luaL_checkstring(L, 1);
	remove(dir);
	return 0;
}

static int system_rename(lua_State *L){
	char * dir1 = (char *)luaL_checkstring(L, 1);
	char * dir2 = (char *)luaL_checkstring(L, 2);
	rename(dir1, dir2);
	return 0;
}

static int system_makeDirectory(lua_State *L){
	char * dir = (char *)luaL_checkstring(L, 1);
	mkdir(dir, 777);
	return 0;
}

//static int system_listDirectory(lua_State *L){
//	if(dirListed == 0){
//		dirListed = 1;
//		dirname = (char *)luaL_checkstring(L, 1);
//		dir = diropen(dirname);
//	}
//	struct stat st;
//	char filename[768];
//	char filename2[768];
//	if (dirnext(dir, filename, &st) == 0){
//		if(st.st_mode & S_IFDIR){
//			sprintf(filename2, "*%s", filename);
//			lua_pushstring(L, filename2);
//		}else{
//			lua_pushstring(L,filename);
//		}
//	}else{
//		dirListed = 0;
//		dirclose(dir);
//		lua_pushstring(L, "##");
//	}
//	return 1;
//}

static int system_listDirectory(lua_State *L){
	if(dirListed == 0){
		dirListed = 1;
		dirname = (char *)luaL_checkstring(L, 1);
		pdir = opendir(dirname);
	}
	char filename[768];
	if((pent=readdir(pdir))!=NULL){
		stat(pent->d_name,&statbuf);
		if(S_ISDIR(statbuf.st_mode)){ // Is directory
			sprintf(filename, "*%s", pent->d_name);
			lua_pushstring(L, filename);
		}else{ // Is not directory
			lua_pushstring(L, pent->d_name);
		}
	}else{ // End
		dirListed = 0;
		closedir(pdir);
		lua_pushstring(L, "##");
	}
	return 1;
}

static int system_getCurrentTime(lua_State *L){
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
	{"changeCurrentDirectory", system_changeCurrentDirectory},
	{"remove", system_remove},
	{"rename", system_rename},
	{"makeDirectory", system_makeDirectory},
	{"listDirectory", system_listDirectory},
	{"getCurrentTime", system_getCurrentTime},
	{"CurrentVramUsed",system_currentVramUsed},
	{"CurrentVramFree",system_currentVramFree},
	{"CurrentPalUsed",system_currentPalUsed},
	{"CurrentPalFree",system_currentPalFree},
	{NULL, NULL}
};

/*
** Open infos library
*/
LUALIB_API int luaopen_system (lua_State *L) {
    luaL_register(L, LUA_SYSTEMLIBNAME, systemlib);
    return 1;
}
