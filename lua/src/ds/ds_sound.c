/*
*
*/

#include <stdlib.h>
#include <stdio.h>

#define ds_sound_c
#define LUA_LIB

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include <ulib/ulib.h>
#include <maxmod9.h>
#include <sys/stat.h>
#include <sys/dir.h>

#include "vars.h"

#include <nds.h>

//the record sample rate
#define sample_rate  8000

//buffer to hold sound data for playback
//u16* sound_buffer = 0;

//buffer which is written to by the arm7
//u16* mic_buffer = 0;

//the length of the current data
//u32 data_length = 0;

//enough hold 5 seconds of 16bit audio
//u32 sound_buffer_size = sample_rate * 2 * 5;

//the mic buffer sent to the arm7 is a double buffer
//every time it is half full the arm7 signals us so we can read the
//data.  I want the buffer to swap about once per frame so i chose a
//buffer size large enough to hold two frames of 16bit mic data
//u32 mic_buffer_size = sample_rate * 2 / 30;


typedef struct soundSample{
	u32 length;
	u16 *s_buffer;
	u16 *m_buffer;
	u16 s_rate;
	u32 s_size;
	u32 m_size;
	bool record;
	bool stereo;
}s_sample;

static int sound_initMic(lua_State *L){
	s_sample *sd = NULL;
	sd = malloc(sizeof(s_sample));
	sd->length = 0;
	sd->s_rate = sample_rate;
	sd->s_size = (sd->s_rate) * 2 * 5;
	sd->m_size = (sd->s_rate) * 2 / 30;
	sd->s_buffer = (u16*)malloc(sd->s_size);
	sd->m_buffer = (u16*)malloc(sd->m_size);
	sd->record = false;
	lua_pushlightuserdata(L, sd);
	return 1;
}

static int sound_micLength(lua_State *L){
	s_sample *sd = lua_touserdata(L, 1);
	lua_pushnumber(L, sd->length);
	return 1;
}

s_sample *sd_buff = NULL;
//mic stream handler
void micHandler(void* data, int length){
	if(!sd_buff->s_buffer || sd_buff->length > sd_buff->s_size) return;
			
	DC_InvalidateRange(data, length);
	dmaCopy(data, ((u8*)sd_buff->s_buffer) + sd_buff->length, length);
		
	sd_buff->length += length;    
}

static int sound_micStartRecord(lua_State *L){
	s_sample *sd = lua_touserdata(L, 1);
	if (!sd->record){
		sd_buff = sd;
		sd->length = 0;
		sd->record = true;
		soundMicRecord(sd->m_buffer, sd->m_size, MicFormat_12Bit, sd->s_rate, micHandler);
	}	
	return 0;
}

static int sound_micStop(lua_State *L){
	s_sample *sd = lua_touserdata(L, 1);
	sd->record = false;
	soundMicOff();
	return 0;
}

static int sound_playSample(lua_State *L){
	s_sample *sd = lua_touserdata(L, 1);
    soundEnable();
    soundPlaySample(sd->s_buffer, SoundFormat_16Bit, sd->length, sd->s_rate, 127, 64, false, 0);
	return 0;
}

static int sound_playNoise(lua_State *L){
	u16 freq = (u16)luaL_checknumber(L, 1);
	u8 vol = (u8)luaL_checknumber(L, 2);
	u8 pan = (u8)luaL_checknumber(L,3);
	u8 sound = soundPlayNoise (freq, vol, pan);
	lua_pushnumber(L, sound);
	return 1;
}

static int sound_playPSG(lua_State *L){
	u8 DC = (u8)luaL_checknumber(L, 1);
	u16 freq = (u16)luaL_checknumber(L, 2);
	u8 vol = (u8)luaL_checknumber(L, 3);
	u8 pan = (u8)luaL_checknumber(L,4);
	u8 sound = soundPlayPSG (DC, freq, vol, pan);
	lua_pushnumber(L, sound);
	return 1;
}

static int sound_stopNoise(lua_State *L){
	u8 sound = (u8)luaL_checknumber(L, 1);
	soundKill(sound);
	return 0;
}

// ########## BANKS ##########

static int sound_loadBank(lua_State *L){
    char * filename = (char *)luaL_checkstring(L, 1);
    assert(L, filename != NULL, "Filename can't be null");
    struct stat file_status;
    if(stat(filename, &file_status) != 0){
        luaL_error(L, "Unable to load %s", filename);
    }
    mmInitDefault(filename);
    return 0;
}

static int sound_unloadBank(lua_State *L){
    mmInitDefaultMem((mm_addr)0);
    return 0;
}

// ########## MODS ##########

static int sound_loadMod(lua_State *L){
    int mod = luaL_checknumber(L, 1);
    assert(L, mod >= 0, "Invalid MOD number");
    mmLoad(mod);
    return 0;
}

static int sound_unloadMod(lua_State *L){
    int mod = luaL_checknumber(L, 1);
    assert(L, mod >= 0, "Invalid MOD number");
    mmUnload(mod);
    return 0;
}

static int sound_startMod(lua_State *L){
    int mod = luaL_checknumber(L, 1);
    int mode = luaL_checknumber(L, 2);
    assert(L, mod >= 0, "Invalid MOD number");
    assert(L, mode == 0 || mode == 1, "Playing mode must be PLAY_ONCE OR PLAY_LOOP");
    if(mode == 0)
        mmStart(mod, MM_PLAY_LOOP);
    else
        mmStart(mod, MM_PLAY_ONCE);
    return 0;
}

static int sound_pause(lua_State *L){
    mmPause();
    return 0;
}

static int sound_resume(lua_State *L){
    mmResume();
    return 0;
}

static int sound_stop(lua_State *L){
    mmStop();
    return 0;
}

static int sound_setPosition(lua_State *L){
    int pos = luaL_checknumber(L, 1);
    assert(L, pos >= 0, "Position must be >= 0");
    mmPosition(pos);
    return 0;
}

static int sound_isActive(lua_State *L){
    lua_pushboolean(L, mmActive());
    return 1;
}

static int sound_startJingle(lua_State *L){
    int mod = luaL_checknumber(L, 1);
    assert(L, mod >= 0, "Invalid MOD number");
    mmJingle(mod);
    return 0;
}

static int sound_setModVolume(lua_State *L){
    int vol = luaL_checknumber(L, 1);
    assert(L, vol >= 0 && vol <= 1024, "Volume must be between 0 and 1024");
    mmSetModuleVolume(vol);
    return 0;
}

static int sound_setJingleVolume(lua_State *L){
    int vol = luaL_checknumber(L, 1);
    assert(L, vol >= 0 && vol <= 1024, "Volume must be between 0 and 1024");
    mmSetJingleVolume(vol);
    return 0;
}

static int sound_setModTempo(lua_State *L){
    int tempo = luaL_checknumber(L, 1);
    assert(L, tempo >= 512 && tempo <= 2048, "Tempo must be between 512 and 2048");
    mmSetModuleTempo(tempo);
    return 0;
}

static int sound_setModPitch(lua_State *L){
    int pitch = luaL_checknumber(L, 1);
    mmSetModulePitch(pitch);
    return 0;
}

// ########## SFX ##########

static int sound_loadSFX(lua_State *L){
    int sfx = luaL_checknumber(L, 1);
    assert(L, sfx >= 0, "Invalid SFX number");
    mmLoadEffect(sfx);
    return 0;
}

static int sound_unloadSFX(lua_State *L){
    int sfx = luaL_checknumber(L, 1);
    assert(L, sfx >= 0, "Invalid SFX number");
    mmUnloadEffect(sfx);
    return 0;
}

static int sound_startSFX(lua_State *L){
    int sfx = luaL_checknumber(L, 1);
    assert(L, sfx >= 0, "Invalid SFX number");
    lua_pushnumber(L, mmEffect(sfx));
    return 1;
}

static int sound_setSFXVolume(lua_State *L){
    int handle = luaL_checknumber(L, 1);
    int vol = luaL_checknumber(L, 2);
    assert(L, vol >= 0 && vol <= 255, "Volume must be between 0 and 255");
    mmEffectVolume(handle, vol);
    return 0;
}

static int sound_setSFXPanning(lua_State *L){
    int handle = luaL_checknumber(L, 1);
    int pan = luaL_checknumber(L, 2);
    assert(L, pan >= 0 && pan <= 255, "Panning must be between 0 and 255");
    mmEffectPanning(handle, pan);
    return 0;
}

static int sound_setSFXPitch(lua_State *L){
    int handle = luaL_checknumber(L, 1);
    int pitch = luaL_checknumber(L, 2);
    mmEffectPanning(handle, pitch);
    return 0;
}

static int sound_setSFXScalePitch(lua_State *L){
    int handle = luaL_checknumber(L, 1);
    int factor = luaL_checknumber(L, 2);
    mmEffectScaleRate(handle, factor);
    return 0;
}

static int sound_stopSFX(lua_State *L){
    int handle = luaL_checknumber(L, 1);
    mmEffectCancel(handle);
    return 0;
}

static int sound_releaseSFX(lua_State *L){
    int handle = luaL_checknumber(L, 1);
    mmEffectRelease(handle);
    return 0;
}

static int sound_stopAllSFX(lua_State *L){
    mmEffectCancelAll();
    return 0;
}

static const luaL_Reg soundlib[] = {
	{"micStartRecord", sound_micStartRecord},
	{"playSample", sound_playSample},
	{"playNoise", sound_playNoise},
	{"playPSG", sound_playPSG},
	{"stopNoise", sound_stopNoise},
	{"initMic", sound_initMic},
	{"micStop", sound_micStop},
	{"micLength", sound_micLength},
    // Banks
    {"loadBank", sound_loadBank},
    {"unloadBank", sound_unloadBank},
    // Mods
    {"loadMod", sound_loadMod},
    {"unloadMod", sound_unloadMod},
    {"startMod", sound_startMod},
    {"pause", sound_pause},
    {"resume", sound_resume},
    {"stop", sound_stop},
    {"setPosition", sound_setPosition},
    {"isActive", sound_isActive},
    {"startJingle", sound_startJingle},
    {"setModVolume", sound_setModVolume},
    {"setJingleVolume", sound_setJingleVolume},
    {"setModTempo", sound_setModTempo},
    {"setModPitch", sound_setModPitch},
    // SFX
    {"loadSFX", sound_loadSFX},
    {"unloadSFX", sound_unloadSFX},
    {"startSFX", sound_startSFX},
    {"setSFXVolume", sound_setSFXVolume},
    {"setSFXPanning", sound_setSFXPanning},
    {"setSFXPitch", sound_setSFXPitch},
    {"setSFXScalePitch", sound_setSFXScalePitch},
    {"stopSFX", sound_stopSFX},
    {"releaseSFX", sound_releaseSFX},
    {"stopAllSFX", sound_stopAllSFX},
    {NULL, NULL}
};

/*
** Open infos library
*/
LUALIB_API int luaopen_sound (lua_State *L) {
    luaL_register(L, LUA_SOUNDLIBNAME, soundlib);
    return 1;
}
