if not ds_system then
    WE_ARE_IN_MLS = true
    end
assert(SCREEN_WIDTH == 256)
assert(SCREEN_HEIGHT == 192)
assert(RAM == 0)
assert(VRAM == 1)
assert(WE_ARE_IN_MLS and (SCREEN_UP == 0) or (SCREEN_UP == 1))
assert(WE_ARE_IN_MLS and (SCREEN_DOWN == 192) or (SCREEN_DOWN == 0))
-- assert(WE_ARE_IN_MLS or SCREEN_BOTH == 2)
assert(WE_ARE_IN_MLS or ATTR_X1 == 0)
assert(WE_ARE_IN_MLS or ATTR_Y1 == 1)
assert(WE_ARE_IN_MLS or ATTR_X2 == 2)
assert(WE_ARE_IN_MLS or ATTR_Y2 == 3)
assert(WE_ARE_IN_MLS or ATTR_X3 == 4)
assert(WE_ARE_IN_MLS or ATTR_Y3 == 5)
assert(WE_ARE_IN_MLS or ATTR_COLOR == 6)
assert(WE_ARE_IN_MLS or ATTR_COLOR1 == 7)
assert(WE_ARE_IN_MLS or ATTR_COLOR2 == 8)
assert(WE_ARE_IN_MLS or ATTR_COLOR3 == 9)
assert(WE_ARE_IN_MLS or ATTR_COLOR4 == 10)
assert(WE_ARE_IN_MLS or ATTR_TEXT == 11)
assert(WE_ARE_IN_MLS or ATTR_VISIBLE == 12)
assert(WE_ARE_IN_MLS or ATTR_FONT == 13)
assert(WE_ARE_IN_MLS or ATTR_IMAGE == 14)
assert(PLAY_LOOP == 0)
assert(PLAY_ONCE == 1)
