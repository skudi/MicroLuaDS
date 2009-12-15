#define BOOT_DIR "/lua"
#define BOOT_FILE "libs.lua"
#define BOOT_FULLPATH BOOT_DIR "/" BOOT_FILE

#include <stdio.h>
#include <stdlib.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#include <ulib/ulib.h>
#include <fat.h>

#include <dswifi9.h>
#include <netinet/in.h>

#include "microlualib/microlualib.h"
#include "microlualib/fixlibs.h"

int main()
{
    // Initialization of µlibrary
    ulInit(UL_INIT_ALL);
    ulInitGfx();
    ulInitText();

    // Sucks banks C-D + drops at 30 fps
    ulInitDualScreenMode();
    
    // Use bright pink as a transparent color
    ulSetTransparentColor(RGB15(31, 0, 31));
    
    fatInitDefault();
    
    struct lua_State *l = lua_open();
    if (!l) {
        ulDebug("\n\n\tFailed to create a Lua state - Push A to Exit\n");
        return 0;
    }
    
    luaL_openlibs(l);
    
    microlua_openlibs(l);
    microlua_fixlibs(l);
    
    if (luaL_loadfile(l, BOOT_FULLPATH)) {
        ulDebug("Error Occured: Couldn't open %s\n", BOOT_FULLPATH);
        return 0;
    }
    
    lua_pushliteral(l, "microlua 1");
    lua_setglobal(l, "_VERSION_DS");
    
    if(lua_pcall(l,0,0,0)) {
        ulDebug(lua_tostring(l, -1));
        lua_pop(l, 1);
        return 0;
    }
    
    lua_close(l);

    return 0;
}
