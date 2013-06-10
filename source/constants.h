#ifndef ds_constants_h
#define ds_constants_h

#include <nds.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"


#define ULUA_VERSION "4.6.1_a [EFS]"

#define ULUA_DIR "/lua/"
#define ULUA_SCRIPTS ULUA_DIR "/scripts/"
#define ULUA_LIBS ULUA_DIR "/libs/"
#define ULUA_BOOT_FILE "boot.lua"
#define ULUA_BOOT_FULLPATH ULUA_DIR ULUA_BOOT_FILE

#define SCREEN_WIDTH 256
#define SCREEN_HEIGHT 192

#define ULUA_RAM  0
#define ULUA_VRAM  1

#define SCREEN_UP 1
#define SCREEN_DOWN 0

#define ALPHA_RESET 100

#define LED_ON PM_LED_ON
#define LED_SLEEP PM_LED_SLEEP
#define LED_BLINK PM_LED_BLINK

#define ATTR_X1 0
#define ATTR_Y1 1
#define ATTR_X2 2
#define ATTR_Y2 3
#define ATTR_X3 4
#define ATTR_Y3 5
#define ATTR_COLOR 6
#define ATTR_COLOR1 7
#define ATTR_COLOR2 8
#define ATTR_COLOR3 9
#define ATTR_COLOR4 10
#define ATTR_TEXT 11
#define ATTR_VISIBLE 12
#define ATTR_FONT 13
#define ATTR_IMAGE 14

#define PLAY_LOOP 0
#define PLAY_ONCE 1

void uLua_pushConstants(lua_State *L);

#endif
