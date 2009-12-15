#include <lua.h>
#include <lauxlib.h>

#include <interrupts.h>
#include <timers.h>

#include "fixlibs.h"

long timer_seconds = 15;

static void on_timer()
{
    timer_seconds++;
}

static void init_timer()
{
    TIMER1_CR = 0;
    TIMER1_DATA = TIMER_FREQ_1024(1000);
    TIMER1_CR = TIMER_ENABLE | TIMER_DIV_1024 | TIMER_IRQ_REQ;
    irqSet(IRQ_TIMER1, on_timer);
    irqEnable(IRQ_TIMER1);
}

static int os_time(lua_State *L)
{
    lua_pushnumber(L, timer_seconds);
    return 1;
}

static const luaL_Reg os_replacement_functions[] = {
	{"time", os_time},
	{NULL, NULL}
};

static int replace_functions(lua_State *L)
{
    luaL_register(L, "os", os_replacement_functions);
    return 1;
}

LUALIB_API void microlua_fixlibs(lua_State *L)
{
    init_timer();
    replace_functions(L);
}

