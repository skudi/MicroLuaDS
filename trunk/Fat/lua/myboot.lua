--
-- INSTRUCTIONS
---------------

-- Type here the code you want to execute before any script loading.
-- This could be a tweak in package.path or some functions or vars definitions,
-- or just a line to load your favorite set of libs.

ds_system.changeCurrentDirectory('/lua')

-- package.path = '/lua/libs/?.lua'

-- DEBUG = true
-- _VERSION_DS = nil

-- dofile('/lua/libs/libs.lua')

-- SOME TESTS
-------------

-- written at root on real nds and in the mls installation
local file = io.open('test.txt', 'w')
file:write('Hello world!')
file:close()

local browsed_file = microbrowser('file', nil,
                                  {"Please choose any file.",
                                   "And then press Start."})

-- works on real nds only:
-- "attempt to yield across metamethod/C-call boundary" on mls
if not WE_ARE_USING_MLS then
    screen.init()
    screen.setSpaceBetweenScreens(10)
    repeat
        ds_controls.read()
        screen.startDrawing2D()
        screen.print(1, 0, 20, "Press A to continue.")
        screen.print(1, 0, 0, "You choosed: "..browsed_file)
        screen.print(1, 0, 40, "_VERSION_DS="..(_VERSION_DS or 'nil'))
        screen.endDrawing()
        screen.waitForVBL()
    until ds_controls.heldA()
    end

-- LAST INSTRUCTIONS
--------------------

-- This last line asks boot.lua to continue the execution after
-- the dofile('/lua/myboot.lua') instruction.
-- If you comment this last line, the execution stops here.
-- If in doubt, please just leave it uncommented.
return 'continue'
