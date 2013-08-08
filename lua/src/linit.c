/*
** $Id: linit.c,v 1.32 2011/04/08 19:17:36 roberto Exp $
** Initialization of libraries for lua.c and other clients
** See Copyright Notice in lua.h
*/


/*
** If you embed Lua in your program and need to open the standard
** libraries, call luaL_openlibs in your program. If you need a
** different set of libraries, copy this file to your project and edit
** it to suit your needs.
*/


#define linit_c
#define LUA_LIB

#include "lua.h"

#include "lualib.h"
#include "lauxlib.h"


/*
** these libs are loaded by lua.c and are readily available to any Lua
** program
*/
static const luaL_Reg loadedlibs[] = {
  {"_G", luaopen_base},
  {LUA_LOADLIBNAME, luaopen_package},
  {LUA_COLIBNAME, luaopen_coroutine},
  {LUA_TABLIBNAME, luaopen_table},
  {LUA_IOLIBNAME, luaopen_io},
  {LUA_OSLIBNAME, luaopen_os},
  {LUA_STRLIBNAME, luaopen_string},
  {LUA_BITLIBNAME, luaopen_bit32},
  {LUA_MATHLIBNAME, luaopen_math},
  {LUA_DBLIBNAME, luaopen_debug},
  {NULL, NULL}
};

/*
** libs from MicroLua
*/
static const luaL_Reg loadedDSlibs[] = {
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
  {LUA_NIFILIBNAME, luaopen_nifi},
  {LUA_RUMBLELIBNAME, luaopen_rumble},
  {LUA_MOTIONLIBNAME, luaopen_motion},
  {LUA_SOUNDLIBNAME, luaopen_sound},
  {LUA_USERLIBNAME, luaopen_user},
  {LUA_TIMERLIBNAME, luaopen_timer},
  {NULL, NULL}
};


/*
** these libs are preloaded and must be required before used
*/
static const luaL_Reg preloadedlibs[] = {
  {NULL, NULL}
};


LUALIB_API void luaL_openlibs (lua_State *L) {
  const luaL_Reg *lib;
  /* call open functions from 'loadedlibs' and set results to global table */
  for (lib = loadedlibs; lib->func; lib++) {
    luaL_requiref(L, lib->name, lib->func, 1);
    lua_pop(L, 1);  /* remove lib */
  }
  /* call open functions of DS libs from 'loadedDSlibs' and set results to global table */
  for (lib = loadedDSlibs; lib->func; lib++) {
    luaL_requiref(L, lib->name, lib->func, 1);
    lua_pop(L, 1);  /* remove lib */
  }
  /* add open functions from 'preloadedlibs' into 'package.preload' table */
  luaL_getsubtable(L, LUA_REGISTRYINDEX, "_PRELOAD");
  for (lib = preloadedlibs; lib->func; lib++) {
    lua_pushcfunction(L, lib->func);
    lua_setfield(L, -2, lib->name);
  }
  lua_pop(L, 1);  /* remove _PRELOAD table */
}

