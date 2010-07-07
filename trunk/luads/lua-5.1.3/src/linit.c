/*
** $Id: linit.c,v 1.14.1.1 2007/12/27 13:02:25 roberto Exp $
** Initialization of libraries for lua.c
** See Copyright Notice in lua.h
*/


#define linit_c
#define LUA_LIB

#include "lua.h"

#include "lualib.h"
#include "lauxlib.h"


static const luaL_Reg lualibs[] = {
  {"", luaopen_base},
  {LUA_LOADLIBNAME, luaopen_package},
  {LUA_TABLIBNAME, luaopen_table},
  {LUA_IOLIBNAME, luaopen_io},
  {LUA_OSLIBNAME, luaopen_os},
  {LUA_STRLIBNAME, luaopen_string},
  {LUA_MATHLIBNAME, luaopen_math},
  {LUA_DBLIBNAME, luaopen_debug},
  
// DS
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


LUALIB_API void luaL_openlibs (lua_State *L) {
  const luaL_Reg *lib = lualibs;
  for (; lib->func; lib++) {
    lua_pushcfunction(L, lib->func);
    lua_pushstring(L, lib->name);
    lua_call(L, 1, 0);
  }
}

