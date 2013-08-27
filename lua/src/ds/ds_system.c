/*
*
*/

#include <stdlib.h>
#include <stdio.h>
#include <malloc.h>
#include <nds.h>

#define ds_system_c
#define LUA_LIB

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "efs_lib.h"

#include <fat.h>
#include <sys/stat.h>
#include <sys/dir.h>
#include <unistd.h>
#include <dirent.h>
#include <string.h>
#include <ulib/ulib.h>

#include "vars.h"

#define lua_geti(L, index, i) lua_pushnumber(L, i); lua_gettable(L, index);
#define lua_seti(L, index, i) lua_pushnumber(L, i); lua_pushvalue(L, -2); lua_settable(L, index); lua_pop(L, 1);

static int system_currentVramUsed(lua_State *L) {
	lua_pushnumber(L, (unsigned int) ulGetTexVramUsedMemory());
	return 1;
}

static int system_currentVramFree(lua_State *L){
	lua_pushnumber(L, (unsigned int) ulGetTexVramAvailMemory());
	return 1;
}

//cette fonction retourne aussi un chiffre bizare
static int system_currentPalUsed(lua_State *L){
	lua_pushnumber(L, (unsigned int) ulGetTexPalUsedMemory());
	return 1;
}

static int system_currentPalFree(lua_State *L){
	lua_pushnumber(L, (unsigned int) ulGetTexPalAvailMemory());
	return 1;
}

static int system_currentDirectory(lua_State *L){
	char path[256];
    getcwd(path, 255);
	lua_pushstring(L, path);
	return 1;
}

static int system_changeDirectory(lua_State *L){
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

static int system_listDirectory(lua_State *L) {
    int mustSwap(lua_State *L, int dirList, int i) {
        // Special function to sort the final table putting folders first
        int isDir1, isDir2, nameCmp;
        char *name1, *name2;
        
        lua_geti(L, dirList, i);
        lua_getfield(L, -1, "isDir");
        isDir1 = lua_toboolean(L, -1);
        lua_getfield(L, -2, "name");
        name1 = (char *)lua_tostring(L, -1);
        lua_pop(L, 3);                      // Removes elem[i], its 'isDir' and its 'name'
        lua_geti(L, dirList, i+1);
        lua_getfield(L, -1, "isDir");
        isDir2 = lua_toboolean(L, -1);
        lua_getfield(L, -2, "name");
        name2 = (char *)lua_tostring(L, -1);
        lua_pop(L, 3);                      // Idem
        
        nameCmp = strcmp(strlwr(name1), strlwr(name2));
        
        return (!isDir1 && isDir2) || ((nameCmp > 0) && (isDir1 == isDir2));
    }
    
    
    struct dirent *elem;
    struct stat st;
    int i = 1, nbItems = 0;
    int swapped = 1;                // Used for sorting the final table
    int dirList = 0;                // Hold the absolute index of the resulting table in the stack
    char cwd[255];                  // Hold the current working directory
    
    const char *dirName = luaL_checkstring(L, 1);
    getcwd(cwd, 255);               // We save the CWD...
    // ... because we set the folder to list as the CWD before listing
    // (it may avoid a libfat bug that makes stat() not working properly)
    chdir(dirName);
    DIR *dir = opendir(dirName);
    if (!dir) luaL_error(L, "cannot open folder %s", dirName);
    
    lua_newtable(L);        // Will hold the entire content of the folder (this is the return value)
    dirList = lua_gettop(L);
    
    while ((elem = readdir(dir))) {             // This traverses the folder
        lua_pushnumber(L, i);                   // Will be the index of this element
        lua_newtable(L);                        // Element of the resulting table in Lua
        // Fill the element
        lua_pushstring(L, elem->d_name);
        lua_setfield(L, -2, "name");
        lua_pushboolean(L, elem->d_type == DT_DIR);
        lua_setfield(L, -2, "isDir");
        stat(elem->d_name, &st);
        lua_pushnumber(L, st.st_size);
        lua_setfield(L, -2, "size");
        // Add the element to the resulting table
        lua_settable(L, dirList);
        i++;
    }
    nbItems = i - 1;
    
    // Now we need to sort the table (we will use modified bubble sorting)
    // We use a custom function to put folders at the top of the table
    while (swapped) {
        swapped = 0;
        
        for (i = 1; i <= nbItems-1; i++) {
            if (mustSwap(L, dirList, i)) {
                lua_geti(L, dirList, i);
                lua_geti(L, dirList, i+1);
                lua_seti(L, dirList, i);
                lua_seti(L, dirList, i+1);
                swapped = 1;
            }
        }
    }
    
    closedir(dir);
    chdir(cwd);
    
    return 1;
}

static int system_setLedBlinkMode(lua_State *L) {
	int mode = (int)luaL_checknumber(L, 1);
	assert(L, mode == PM_LED_ON || mode == PM_LED_SLEEP || mode == PM_LED_BLINK, "Bad led blink mode");
	ledBlink(mode);
	
	return 0;
}

static int system_systemShutDown(lua_State *L) {
	systemShutDown();
	
	return 0;
}

static int system_systemSleep(lua_State *L) {
	systemSleep();
	
	return 0;
}

static const luaL_Reg systemlib[] = {
	{"currentDirectory", system_currentDirectory},
	{"changeDirectory", system_changeDirectory},
	{"remove", system_remove},
	{"rename", system_rename},
	{"makeDirectory", system_makeDirectory},
	{"listDirectory", system_listDirectory},
	{"CurrentVramUsed",system_currentVramUsed},
	{"CurrentVramFree",system_currentVramFree},
	{"CurrentPalUsed",system_currentPalUsed},
	{"CurrentPalFree",system_currentPalFree},
	{"setLedBlinkMode", system_setLedBlinkMode},
	{"shutDown", system_systemShutDown},
	{"sleep", system_systemSleep},
	{NULL, NULL}
};

/*
** Open infos library
*/
LUALIB_API int luaopen_system (lua_State *L) {
    luaL_register(L, LUA_SYSTEMLIBNAME, systemlib);
	
    return 1;
}
