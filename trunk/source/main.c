#define COMPILE_FOR_DS 0    // 1: yes, 0: no$gba

#if COMPILE_FOR_DS
#define BOOT_DIR "/lua/"
#else
#define BOOT_DIR ""
#endif

#define BOOT_FILE "libs.lua"
#define BOOT_FULLPATH BOOT_DIR BOOT_FILE

#include <stdio.h>
#include <stdlib.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#include <ulib/ulib.h>
#include <fat.h>

#include <dswifi9.h>
#include <netinet/in.h>

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
    
    // transfer COMPILE_FOR_DS C constant to Lua
    lua_pushnumber(l, COMPILE_FOR_DS);
    lua_setglobal(l, "COMPILE_FOR_DS");
    
    luaL_openlibs(l);
    
    if (luaL_loadfile(l, BOOT_FULLPATH)) {
        ulDebug("Error Occured: Couldn't open %s (%s mode)\n", BOOT_FULLPATH, 
                COMPILE_FOR_DS ? "DS" : "EMU");
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
