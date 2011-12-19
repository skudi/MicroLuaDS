--[[
    MICROLUA BOOTSTRAP
    
    Based on Christophe "Grahack" Gragnic's idea in October 2009

]]--



-- You can override this file by writing a new one with the name defined just below, in the same "/lua" directory.
ULUA_MYBOOT = ""
-- Then, if you want "boot.lua" to be executed just after yours, make your own bootstrap return the String "continue"


-- Developers can add some code here, this way it will be executed before anything else.


local function loadMyboot()
    local msg = dofile("/lua/" .. ULUA_MYBOOT)
    return msg
end
mybootLoaded, msg = pcall(loadMyboot)

if not mybootLoaded and not msg:match("cannot open /lua/" .. ULUA_MYBOOT) then
    -- An error occured while running the special bootstrap.
    local file = io.open("/lua/microlua.log", "a")
    file:write("<" .. ULUA_MYBOOT .. ">" .. tostring(msg) .. "</" .. ULUA_MYBOOT .. ">\n")
    file:close()
elseif mybootLoaded then
    -- The special bootstrap has been found, and no error occured while running it.
    -- We can exit here if it is not asked to continue.
    if msg ~= "continue" then
        os.exit()
    else
        -- Here developers can add some code after the personal bootstrap has been executed.
    end
end

-- And finally, let's launch MicroLua :)
dofile("/lua/libs/libs.lua")
