/*
*
*/

#include <stdlib.h>
#include <stdio.h>

#define ds_controls_c
#define LUA_LIB

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include <ulib/ulib.h>

// Stylus

static int controls_read(lua_State *L){
    ulReadKeys(0);
    return 0;
}

static int controls_stylusX(lua_State *L){
    lua_pushnumber(L, ul_keys.touch.x);
    return 1;
}

static int controls_stylusY(lua_State *L){
    lua_pushnumber(L, ul_keys.touch.y);
    return 1;
}

static int controls_stylusHeld(lua_State *L){
    lua_pushboolean(L, ul_keys.touch.held);
    return 1;
}

static int controls_stylusReleased(lua_State *L){
    lua_pushboolean(L, ul_keys.touch.released);
    return 1;
}

static int controls_stylusDoubleClick(lua_State *L){
    lua_pushboolean(L, ul_keys.touch.doubleClick);
    return 1;
}

static int controls_stylusDeltaX(lua_State *L){
    lua_pushnumber(L, ul_keys.touch.deltaX);
    return 1;
}

static int controls_stylusDeltaY(lua_State *L){
    lua_pushnumber(L, ul_keys.touch.deltaY);
    return 1;
}

// Held

static int controls_heldA(lua_State *L){
    lua_pushboolean(L, ul_keys.held.A);
    return 1;
}

static int controls_heldB(lua_State *L){
    lua_pushboolean(L, ul_keys.held.B);
    return 1;
}

static int controls_heldX(lua_State *L){
    lua_pushboolean(L, ul_keys.held.X);
    return 1;
}

static int controls_heldY(lua_State *L){
    lua_pushboolean(L, ul_keys.held.Y);
    return 1;
}

static int controls_heldStart(lua_State *L){
    lua_pushboolean(L, ul_keys.held.start);
    return 1;
}

static int controls_heldSelect(lua_State *L){
    lua_pushboolean(L, ul_keys.held.select);
    return 1;
}

static int controls_heldR(lua_State *L){
    lua_pushboolean(L, ul_keys.held.R);
    return 1;
}

static int controls_heldL(lua_State *L){
    lua_pushboolean(L, ul_keys.held.L);
    return 1;
}

static int controls_heldUp(lua_State *L){
    lua_pushboolean(L, ul_keys.held.up);
    return 1;
}

static int controls_heldDown(lua_State *L){
    lua_pushboolean(L, ul_keys.held.down);
    return 1;
}

static int controls_heldLeft(lua_State *L){
    lua_pushboolean(L, ul_keys.held.left);
    return 1;
}

static int controls_heldRight(lua_State *L){
    lua_pushboolean(L, ul_keys.held.right);
    return 1;
}

static const luaL_Reg controlslib[] = {
    // Stylus
    {"read", controls_read},
    {"stylusX", controls_stylusX},
    {"stylusY", controls_stylusY},
    {"stylusHeld", controls_stylusHeld},
    {"stylusReleased", controls_stylusReleased},
    {"stylusDoubleClick", controls_stylusDoubleClick},
    {"stylusDeltaX", controls_stylusDeltaX},
    {"stylusDeltaY", controls_stylusDeltaY},
    // Held
    {"heldA", controls_heldA},
    {"heldB", controls_heldB},
    {"heldX", controls_heldX},
    {"heldY", controls_heldY},
    {"heldStart", controls_heldStart},
    {"heldSelect", controls_heldSelect},
    {"heldR", controls_heldR},
    {"heldL", controls_heldL},
    {"heldUp", controls_heldUp},
    {"heldDown", controls_heldDown},
    {"heldLeft", controls_heldLeft},
    {"heldRight", controls_heldRight},
    {NULL, NULL}
};

/*
** Open infos library
*/
LUALIB_API int luaopen_controls(lua_State *L) {
    luaL_register(L, LUA_CONTROLSLIBNAME, controlslib);
    return 1;
}
