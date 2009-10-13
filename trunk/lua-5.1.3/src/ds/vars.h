#define SCREEN_UP 0
#define SCREEN_DOWN 1
#define SCREEN_BOTH 2

#define assert(l, cond, text)	if(!(cond)){ luaL_error(l, text); return 0;}

#define	LUA_RAM  0
#define	LUA_VRAM  1

int SCREEN_UP_DISPLAY;
int SCREEN_DOWN_DISPLAY;
int spaceBetweenScreens;
int decale;

typedef struct mapObj{
	UL_IMAGE * image;
	unsigned short * table;
	int width, height;
	int tileWidth, tileHeight;
	int scrollX, scrollY;
	int spaceX, spaceY;
} Map;


