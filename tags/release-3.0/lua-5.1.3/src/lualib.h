/*
** $Id: lualib.h,v 1.36.1.1 2007/12/27 13:02:25 roberto Exp $
** Lua standard libraries
** See Copyright Notice in lua.h
*/


#ifndef lualib_h
#define lualib_h

#include "lua.h"

/* Key to file-handle type */
#define LUA_FILEHANDLE		"FILE*"


#define LUA_COLIBNAME	"coroutine"
LUALIB_API int (luaopen_base) (lua_State *L);

#define LUA_TABLIBNAME	"table"
LUALIB_API int (luaopen_table) (lua_State *L);

#define LUA_IOLIBNAME	"io"
LUALIB_API int (luaopen_io) (lua_State *L);

#define LUA_OSLIBNAME	"os"
LUALIB_API int (luaopen_os) (lua_State *L);

#define LUA_STRLIBNAME	"string"
LUALIB_API int (luaopen_string) (lua_State *L);

#define LUA_MATHLIBNAME	"math"
LUALIB_API int (luaopen_math) (lua_State *L);

#define LUA_DBLIBNAME	"debug"
LUALIB_API int (luaopen_debug) (lua_State *L);

#define LUA_LOADLIBNAME	"package"
LUALIB_API int (luaopen_package) (lua_State *L);


/* open all previous libraries */
LUALIB_API void (luaL_openlibs) (lua_State *L); 

// DS
#define LUA_SCREENLIBNAME "screen"
LUALIB_API int (luaopen_screen) (lua_State *L);
#define LUA_CONTROLSLIBNAME "ds_controls"
LUALIB_API int (luaopen_controls) (lua_State *L);
#define LUA_IMAGELIBNAME "Image"
LUALIB_API int (luaopen_image) (lua_State *L);
#define LUA_SYSTEMLIBNAME "ds_system"
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
#define LUA_RUMBLELIBNAME "Rumble"
LUALIB_API int (luaopen_rumble) (lua_State *L);
#define LUA_MOTIONLIBNAME "Motion"
LUALIB_API int (luaopen_motion) (lua_State *L);
#define LUA_SOUNDLIBNAME "Sound"
LUALIB_API int (luaopen_sound) (lua_State *L);

#ifndef lua_assert
#define lua_assert(x)	((void)0)
#endif


#endif
