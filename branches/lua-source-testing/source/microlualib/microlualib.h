#ifndef microlualib_h
#define microlualib_h

#include <lua.h>

LUALIB_API void microlua_openlibs (lua_State *L);

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

#endif
