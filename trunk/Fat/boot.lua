--
-- Microlua bootstrap.
--

-- author: Christophe Gragnic (Grahack), october 2009

-- Override this file writing a 'myboot.lua' in the same /lua directory.

-- MicroLuaSimulator compatibility definitions
if not screen.init then
    WE_ARE_USING_MLS = true
    screen.init = function() end
    screen.setSpaceBetweenScreens = function() end
    screen.startDrawing2D = startDrawing
    screen.endDrawing = stopDrawing
    screen.waitForVBL = function() end
    ds_system = {}
    ds_system.changeCurrentDirectory = System.changeDirectory
    ds_system.currentDirectory = System.currentDirectory
    listDirectory = System.listDirectory
    ds_controls = Controls
    ds_controls_mt = {__index=function(_, key)
        if string.sub(key, 1, 4) == 'held' then
            return function() return Keys.held[string.sub(key, 5)] end
            end
        end}
    setmetatable(ds_controls, ds_controls_mt)
    -- SCREEN_UP = 0, SCREEN_DOWN = 192
else
    SCREEN_UP = 1
    SCREEN_DOWN = 0
    -- this next function was written by Risike
    listDirectory = function(dir)
        assert(dir ~= nil, "Parameter must be a directory name")
        tabFile = {}
        tabDir = {}
        ret = ds_system.listDirectory(dir)
        while ret ~= "##" do
            if string.sub(ret,1 , 1) ~= "ù" then -- Strange but useful...
                obj = {}
                if string.sub(ret,1 , 1) == "*" then
                    obj.name = string.sub(ret, 2)
                    obj.isDir = true
                    table.insert(tabDir, obj)
                else
                    obj.name = ret
                    obj.isDir = false
                    table.insert(tabFile, obj)
                    end
                end
            ret = ds_system.listDirectory(dir)
            end
        tab = {}
        for key, value in pairs(tabDir) do
            table.insert(tab, value)
            end
        for key, value in pairs(tabFile) do
            table.insert(tab, value)
            end
        tabDir = nil
        tabFile = nil
        return tab
        end
    end
-- end mls definitions

-- We're quite sure you'll need the screen to be initialised.
screen.init()
screen.setSpaceBetweenScreens(10)

-- browses the file system and returns the choosen file or directory
-- `file_or_dir`: can be 'file', 'dir' or nil (both types)
-- `path`: nil or a path to a dir to start with
-- `instructions`: a small text to explain what the user should do, or
--                 nil (there is a default set of instructions)
-- `extension`: nil or the expected extension a _file_ must end with, please
--              provide the extension WITHOUT the dot.
function microbrowser(file_or_dir, path, instructions, extension)
    if path then
        ds_system.changeCurrentDirectory(path)
        end
    local notice
    local dir_items
    local selected_item = 1  -- there will be at least the . directory
    local current_item = '.'
    local current_item_type = 'dir'
    local line_h = 14
    local file_or_dir_str
    if not file_or_dir then
        file_or_dir_str = "file or a directory"
    elseif file_or_dir == 'file' then
        file_or_dir_str = "file"
    elseif file_or_dir == 'dir' then
        file_or_dir_str = "directory"
    else
        error("`file_or_dir`: can be 'file', 'dir' or nil (both types)")
        end
    local instructions = instructions or {
       string.format("Please choose a %s", file_or_dir_str),
       "using arrows only, then press Start."}
    local extension = extension and string.lower(extension)
    while true do
        -- post beginning of the loop
        ds_controls.read()
        screen.startDrawing2D()
        -- user input
        -- if dir_items nil-ed, then it is rebuilt
        if ds_controls.heldUp() and not prev_u then
            prev_u = true
            notice = ''
            if selected_item > 1 then
                selected_item = selected_item - 1
                end
        elseif not ds_controls.heldUp() then
            prev_u = false
            end
        if ds_controls.heldDown() and not prev_d then
            prev_d = true
            notice = ''
            if selected_item < #dir_items then
                selected_item = selected_item + 1
                end
        elseif not ds_controls.heldDown() then
            prev_d = false
            end
        if ds_controls.heldLeft() and not prev_l then
            prev_l = true
            notice = ''
            dir_items = nil
            ds_system.changeCurrentDirectory("..")
        elseif not ds_controls.heldLeft() then
            prev_l = false
            end
        if ds_controls.heldRight() and not prev_r then
            prev_r = true
            notice = ''
            if dir_items[selected_item].isDir then
                ds_system.changeCurrentDirectory(dir_items[selected_item].name)
                dir_items = nil
            else
                notice = "Not a directory!"
                end
        elseif not ds_controls.heldRight() then
            prev_r = false
            end
        -- dirs and files list, only to rebuild if nil
        if not dir_items then
            selected_item = 1
            dir_items = listDirectory(ds_system.currentDirectory())
            local dirs = {}
            local files = {}
            for _, dir_item in ipairs(dir_items) do
                if dir_item.isDir then
                    table.insert(dirs, dir_item)
                else
                    table.insert(files, dir_item)
                    end
                end
                dir_items = {}
            function by_name(tbl1, tbl2) return tbl1.name < tbl2.name end
            table.sort(dirs, by_name)
            table.sort(files, by_name)
            for _, item in ipairs(dirs) do
                table.insert(dir_items, item)
                end
            for _, item in ipairs(files) do
                table.insert(dir_items, item)
                end
            end
        -- generate string to return and to display (before checking Start button)
        current_item = ds_system.currentDirectory()
        if current_item ~= '/' then
            current_item = current_item..'/'
            end
        current_item = current_item..dir_items[selected_item].name
        current_item_type = dir_items[selected_item].isDir and 'dir' or 'file'
        -- checking the Start button
        if ds_controls.heldStart() then
            if file_or_dir == 'file' and dir_items[selected_item].isDir then
                notice = "You must point to a file!"
            elseif file_or_dir == 'dir' and not dir_items[selected_item].isDir then
                notice = "You must point to a directory!"
            elseif extension and
                   not dir_items[selected_item].isDir and
                   not string.find(string.lower(dir_items[selected_item].name),
                                   '%.'..extension..'$') then
                notice = string.format("Your file must end with '.%s'!", extension)
            else
                return current_item
                end
            end
        -- help message
        for line_number, line in ipairs(instructions) do
            -- scr, x, y, txt, color
            screen.print(SCREEN_UP, 0, line_number * line_h, line)
            end
        -- current directory and file
        -- #instructions + something because we write after the instructions
        screen.print(SCREEN_UP, 0, (#instructions + 2) * line_h,
           string.format("Browsing %s", ds_system.currentDirectory()))
        local offset = 0
        if ds_system.currentDirectory() == '/' then
            offset = 1
        else
            offset = 2
            end
        screen.print(SCREEN_UP, 0, (#instructions + 3) * line_h,
           string.format("Pointing to a %s: %s",
              current_item_type,
              string.sub(current_item, string.len(ds_system.currentDirectory()) + offset)))
        if notice then
            screen.print(SCREEN_UP, 0, (#instructions + 5) * line_h, notice)
            end
        -- pre end of the loop
        screen.endDrawing()
        screen.waitForVBL()
        end
    end

local function load_myboot()
    local message = dofile('/lua/myboot.lua')
    return message
    end

myboot_loaded, message = pcall(load_myboot)

if myboot_loaded then
    -- myboot.lua was found and no error occured, we can exit here if not asked
    -- to continue ('continue' returned in myboot.lua).
    if message ~= 'continue' then
        os.exit()
        end
elseif not message:match(WE_ARE_USING_MLS and
                         'cannot open //lua/myboot.lua' or
                         'cannot open /lua/myboot.lua') then
    -- an error occured but was not about a missing myboot.lua
    error('<myboot>'..tostring(message)..'</myboot>')
    end

local path_to_execute
if not _VERSION_DS then
    local instructions = {
       "Unknown version of the Lua interpreter.",
       "Please choose the set of libs to use",
       "using arrows only, then press Start.",
       "",
       "In general it is a 'libs.lua' file."
    }
    path_to_execute = microbrowser('file', nil, instructions, 'lua')
else
    -- Parse _VERSION_DS to extract 'name space APInum' and decide which
    -- libs to load. For now no .nds has an API number, but if ever one has we
    -- load the good old default libs at the good old default location.
    path_to_execute = '/lua/libs/libs.lua'
    end
    
dofile(path_to_execute)
