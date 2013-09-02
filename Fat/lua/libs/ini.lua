-- Library by Risike
-- Modified by geeker

-- Trim a string
function stringTrim(s)
 assert(s ~= nil, "String can't be nil")
 local toret = (string.gsub(s, "^%s*(.-)%s*$", "%1"))
 local i = #toret
 while string.sub(toret, i, i) == " " and i > 0 do --remove end spaces
  toret = string.sub(toret, 0, -2)
  i = i - 1
 end
 i = nil
 return toret
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
 local structure
 for key, value in pairs(tab) do
  if i ~= 0 then
   f:write("\n")
  end
  --if value is a table
  if type(value) == "table" then
   structure = (structure or "table")
   assert(structure == "table", "bad table structure.")
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
  --if value is an other value (what ???)
  else
   structure = (structure or "simple")
   assert(structure == "simple", "bad table structure.")
   key, value = stringTrim(key), stringTrim(tostring(value))
   f:write(key.."="..value)
  end
  --increment
  i = i + 1
 end
 f:close()
end

-- Load an INI file
-- path: path of the file to read
-- mode (boolean): use simple INI structure
INI.load = function(path, mode)
 assert(path ~= nil, "Path can't be nil")
 local f = io.open(path, "r")
 if not f then return nil end
 local tab = {}
 local line = ""
 local newLine
 local pos = 0
 --default loading mode
 if not mode then
  local i
  local currentTag = nil
  local found = false
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
 --simple mode
 else
  while line do
   line = f:read("*l")
   if not line then break end
   --remove comments
   newline = line
   line = ""
   for i = 1, #line do
    if newline:sub(i, i) == ";" then
	 break
	else
	 line = (line..newline:sub(i, i))
	end
   end
   --get the value
   if string.gsub(line, " ", "") ~= "" then
    pos = string.find(line, "=")
	assert(pos, "bad INI file structure")
	tab[line:sub(1, pos-1)] = line:sub(pos+1, -1)
   end
   --
  end
 end
 --
 f:close()
 return tab
end

-- crypt a table
-- tab: table to crypt
-- key: number to use
function table.crypt(tab, key)
 assert(type(tab) == "table", "First parameter must be a table")
 assert(type(key) == "number", "Key must be a number")
 local tcrypt = {}
 for k, v in pairs(tab) do
  if type(v) == "table" then
   tcrypt[k] = {}
   for k2, v2 in pairs(v) do
    v2 = tostring(v2)
    k2 = tostring(k2)
    k2 = string.reverse(string.sub(k2, key, -1)..string.sub(k2, 0, key-1))
    tcrypt[k][k2] = string.reverse(string.sub(v2, key, -1)..string.sub(v2, 0, key-1))
   end
  else
   v = tostring(v)
   k = tostring(k)
   k = string.reverse(string.sub(k, key, -1)..string.sub(k, 0, key-1))
   tcrypt[k] = string.reverse(string.sub(v, key, -1)..string.sub(v, 0, key-1))
  end
 end
 return tcrypt
end
