/*
** $Id: lualib.h,v 1.43 2011/12/08 12:11:37 roberto Exp $
** Lua standard libraries
** See Copyright Notice in lua.h
*/


#ifndef lualib_h
#define lualib_h

#include "lua.h"



LUAMOD_API int (luaopen_base) (lua_State *L);

#define LUA_COLIBNAME	"coroutine"
LUAMOD_API int (luaopen_coroutine) (lua_State *L);

#define LUA_TABLIBNAME	"table"
LUAMOD_API int (luaopen_table) (lua_State *L);

#define LUA_IOLIBNAME	"io"
LUAMOD_API int (luaopen_io) (lua_State *L);

#define LUA_OSLIBNAME	"os"
LUAMOD_API int (luaopen_os) (lua_State *L);

#define LUA_STRLIBNAME	"string"
LUAMOD_API int (luaopen_string) (lua_State *L);

#define LUA_BITLIBNAME	"bit32"
LUAMOD_API int (luaopen_bit32) (lua_State *L);

#define LUA_MATHLIBNAME	"math"
LUAMOD_API int (luaopen_math) (lua_State *L);

#define LUA_DBLIBNAME	"debug"
LUAMOD_API int (luaopen_debug) (lua_State *L);

#define LUA_LOADLIBNAME	"package"
LUAMOD_API int (luaopen_package) (lua_State *L);


/* open all previous libraries */
LUALIB_API void (luaL_openlibs) (lua_State *L);


/* MicroLua */
#define LUA_SCREENLIBNAME "screen"
LUALIB_API int (luaopen_screen) (lua_State *L);

#define LUA_CONTROLSLIBNAME "Controls"
LUALIB_API int (luaopen_controls) (lua_State *L);

#define LUA_IMAGELIBNAME "Image"
LUALIB_API int (luaopen_image) (lua_State *L);

#define LUA_SYSTEMLIBNAME "System"
LUALIB_API int (luaopen_system) (lua_State *L);

#define LUA_MAPLIBNAME "Map"
LUALIB_API int (luaopen_map) (lua_State *L);

#define LUA_FONTLIBNAME "Font"
LUALIB_API int (luaopen_font) (lua_State *L);

#define LUA_COLORLIBNAME "Color"
LUALIB_API int (luaopen_color) (lua_State *L);

#define LUA_SCROLLMAPLIBNAME "ScrollMap"
LUALIB_API int (luaopen_scrollmap) (lua_State *L);

#define LUA_CANVASLIBNAME "Canvas"
LUALIB_API int (luaopen_canvas) (lua_State *L);

#define LUA_WIFILIBNAME "Wifi"
LUALIB_API int (luaopen_wifi) (lua_State *L);

#define LUA_NIFILIBNAME "Nifi"
LUALIB_API int (luaopen_nifi) (lua_State *L);

#define LUA_RUMBLELIBNAME "Rumble"
LUALIB_API int (luaopen_rumble) (lua_State *L);

#define LUA_MOTIONLIBNAME "Motion"
LUALIB_API int (luaopen_motion) (lua_State *L);

#define LUA_SOUNDLIBNAME "Sound"
LUALIB_API int (luaopen_sound) (lua_State *L);

#define LUA_USERLIBNAME "dsUser"
LUALIB_API int (luaopen_user) (lua_State *l);

#define LUA_TIMERLIBNAME "Timer"
LUALIB_API int (luaopen_timer) (lua_State *L);



#if !defined(lua_assert)
#define lua_assert(x)	((void)0)
#endif


#endif
