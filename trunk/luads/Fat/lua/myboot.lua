--[[
    DEFAULT MYBOOT
    
    Here is the default example personal bootstrap.
    Please note that it is *NOT* loaded by "boot.lua". If you want to, put "myboot.lua"
    into ULUA_MYBOOT.
]]--



-- You may wish to change the directory open by default, that is to say the "scripts" directory.
-- The same manipulation can be used to change other constants.
ULUA_SCRIPTS = "/lua/myOwnScriptsDir/"

-- You may wish to specify a fake version (you evil).
ULUA_VERSION = "1.3.37"

-- You may wish to change the directory used to store the libs loaded with "require" (or at least, define it...).
package.path = "lua/libs/?.lua"

-- You may wish to write some log on MicroLua's opening.
local file = io.open("/lua/microlua.log", "a")
file:write("Hello world.")
file:close()


-- And finally, if you wish to come back to the "normal" bootstrap (which is the best thing to do).
return "continue"
