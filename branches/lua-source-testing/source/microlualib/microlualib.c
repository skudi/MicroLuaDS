#define linit_c
#define LUA_LIB

#include <lua.h>

#include <lualib.h>
#include <lauxlib.h>

#include "microlualib.h"

static const luaL_Reg microlualibs[] = {
  {LUA_SCREENLIBNAME, luaopen_screen},  
  {LUA_CONTROLSLIBNAME, luaopen_controls},    
  {LUA_IMAGELIBNAME, luaopen_image}, 
  {LUA_SYSTEMLIBNAME, luaopen_system},
  {LUA_MAPLIBNAME, luaopen_map}, 
  {LUA_FONTLIBNAME, luaopen_font},
  {LUA_COLORLIBNAME, luaopen_color},
  {LUA_SCROLLMAPLIBNAME, luaopen_scrollmap},
  {LUA_CANVASLIBNAME, luaopen_canvas},
  {LUA_WIFILIBNAME, luaopen_wifi},  
  {LUA_RUMBLELIBNAME, luaopen_rumble},
  {LUA_MOTIONLIBNAME, luaopen_motion},
  {LUA_SOUNDLIBNAME, luaopen_sound},
  {NULL, NULL}
};


LUALIB_API void microlua_openlibs (lua_State *L) {
  const luaL_Reg *lib = microlualibs;
  for (; lib->func; lib++) {
    lua_pushcfunction(L, lib->func);
    lua_pushstring(L, lib->name);
    lua_call(L, 1, 0);
  }
}
