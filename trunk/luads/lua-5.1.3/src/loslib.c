/*
** $Id: loslib.c,v 1.19.1.3 2008/01/18 16:38:18 roberto Exp $
** Standard Operating System library
** See Copyright Notice in lua.h
*/


#include <errno.h>
#include <locale.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define loslib_c
#define LUA_LIB

#include "lua.h"

#include "lauxlib.h"
#include "lualib.h"

#include <nds.h>

long osTime;

static int os_pushresult (lua_State *L, int i, const char *filename) {
  int en = errno;  /* calls to Lua API may change this value */
  if (i) {
    lua_pushboolean(L, 1);
    return 1;
  }
  else {
    lua_pushnil(L);
    lua_pushfstring(L, "%s: %s", filename, strerror(en));
    lua_pushinteger(L, en);
    return 3;
  }
}


static int os_remove (lua_State *L) {
  const char *filename = luaL_checkstring(L, 1);
  return os_pushresult(L, remove(filename) == 0, filename);
}


static int os_rename (lua_State *L) {
  const char *fromname = luaL_checkstring(L, 1);
  const char *toname = luaL_checkstring(L, 2);
  return os_pushresult(L, rename(fromname, toname) == 0, fromname);
}


static int os_tmpname (lua_State *L) {
  char buff[LUA_TMPNAMBUFSIZE];
  int err;
  lua_tmpnam(buff, err);
  if (err)
    return luaL_error(L, "unable to generate a unique filename");
  lua_pushstring(L, buff);
  return 1;
}


static int os_getenv (lua_State *L) {
  lua_pushstring(L, getenv(luaL_checkstring(L, 1)));  /* if NULL push nil */
  return 1;
}

static int os_exit (lua_State *L) {
  exit(luaL_optint(L, 1, EXIT_SUCCESS));
}

void OnTimer(){
	osTime++;
}

static int os_initTimer (lua_State *L) {
	TIMER1_CR = 0;
	TIMER1_DATA = TIMER_FREQ_1024(1000);
	TIMER1_CR = TIMER_ENABLE | TIMER_DIV_1024 | TIMER_IRQ_REQ;		
	irqSet(IRQ_TIMER1, OnTimer);
	irqEnable(IRQ_TIMER1);
	osTime = 0;
	return 0;
}

static int os_time (lua_State *L) {
	lua_pushnumber(L, osTime);
	return 1;
}

static const luaL_Reg syslib[] = {
  {"exit",      os_exit},
  {"getenv",    os_getenv},
  {"remove",    os_remove},
  {"rename",    os_rename},
  {"tmpname",   os_tmpname},
  {"initTimer",   os_initTimer},
  {"time",   os_time},
  {NULL, NULL}
};

/* }====================================================== */



LUALIB_API int luaopen_os (lua_State *L) {
  luaL_register(L, LUA_OSLIBNAME, syslib);
  return 1;
}

