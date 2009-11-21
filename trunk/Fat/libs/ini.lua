-- Library by Risike

-- Trim a string
function stringTrim(s)
    assert(s ~= nil, "String can't be nil")
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

INI = {}

-- Save a table into an INI file
-- path: path of the file to write
-- tab: table to save
INI.save = function(path, tab)
    assert(path ~= nil, "Path can't be nil")
    assert(type(tab) == "table", "Second parameter must be a table")
    local f = io.open(path, "w")
    local i = 0
    for key, value in pairs(tab) do
        if i ~= 0 then
            f:write("\n")
        end
        f:write("["..key.."]".."\n")
        for key2, value2 in pairs(tab[key]) do
            key2 = stringTrim(key2)
            value2 = stringTrim(value2)
            key2 = key2:gsub(";", "\\;")
            key2 = key2:gsub("=", "\\=")
            value2 = value2:gsub(";", "\\;")
            value2 = value2:gsub("=", "\\=")
            f:write(key2.."="..value2.."\n")
        end
        i = i + 1
    end
    f:close()
end

-- Load an INI file
-- path: path of the file to read
INI.load = function(path)
    assert(path ~= nil, "Path can't be nil")
    local f = io.open(path, "r")
    local tab = {}
    local line = ""
    local newLine
    local i
    local currentTag = nil
    local found = false
    local pos = 0
    while line ~= nil do
        found = false
        line = line:gsub("\\;", "#_!36!_#") -- to keep \;
        line = line:gsub("\\=", "#_!71!_#") -- to keep \=
        if line ~= "" then
            -- Delete comments
            newLine = line
            line = ""
            for i=1, string.len(newLine) do
                if string.sub(newLine, i, i) ~= ";" then
                    line = line..newLine:sub(i, i)
                else
                    break
                end
            end
            line = stringTrim(line)
            -- Find tag
            if line:sub(1, 1) == "[" and line:sub(line:len(), line:len()) == "]" then
                currentTag = stringTrim(line:sub(2, line:len()-1))
                tab[currentTag] = {}
                found = true
            end
            -- Find key and values
            if not found and line ~= "" then
                pos = line:find("=")
                if pos == nil then
                    error("Bad INI file structure")
                end
                line = line:gsub("#_!36!_#", ";")
                line = line:gsub("#_!71!_#", "=")
                tab[currentTag][stringTrim(line:sub(1, pos-1))] = stringTrim(line:sub(pos+1, line:len()))
                found = true
            end
        end
        line = f:read("*line")
    end
    f:close()
    return tab
end

