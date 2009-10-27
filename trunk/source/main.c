#define COMPILE_FOR_DS 1	// 1: yes, 0: no$gba

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

	//ulDebug("Starting Lua...\n");
	struct lua_State *l = lua_open();
	if(!l)
	{
		ulDebug("\n\n\tFailed to create a Lua state - Push A to Exit\n");
		return 0;
	}

	luaL_openlibs(l);
	if(!COMPILE_FOR_DS){
		if(luaL_loadfile(l,"boot.lua")){
			ulDebug("Error Occured: Couldn't open libs.lua\n");
			return 0;
		}
	}else{
		if(luaL_loadfile(l,"/lua/boot.lua")){
			ulDebug("Error Occured: Couldn't open libs.lua\n");
			return 0;
		}
	}
	
	//ulDebug("Lua started !\n");
	
	if(lua_pcall(l,0,0,0))
	{
		ulDebug(lua_tostring(l, -1));
		lua_pop(l, 1);
		return 0;
	}
	
	lua_close(l);

	return 0;
}
