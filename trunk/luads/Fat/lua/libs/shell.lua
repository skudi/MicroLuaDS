System.changeDirectory("/lua/scripts")
files = {}
nbFiles = 0
selectedFile = {}

status, err = pcall(function()
	local configs
    configs = INI.load("/lua/libs/shell.ini")
	local f
	f = loadstring("return Color.new("..configs["colors"]["bgupcolor"]..")")
	bgupcolor = f()
	f = loadstring("return Color.new("..configs["colors"]["bgdowncolor"]..")")
	bgdowncolor = f()
	f = loadstring("return Color.new("..configs["colors"]["fgupcolor"]..")")
	fgupcolor = f()
	f = loadstring("return Color.new("..configs["colors"]["filenamecolor"]..")")
	filenamecolor = f()
	f = loadstring("return Color.new("..configs["colors"]["dirnamecolor"]..")")
	dirnamecolor = f()
	f = loadstring("return Color.new("..configs["colors"]["selectcolor"]..")")
	selectcolor = f()
	f = loadstring("return Color.new("..configs["colors"]["microluacolor"]..")")
	microluacolor = f()
end)
assert(err == nil, "Malformed shell.ini file")

function fileExists(fname)
	local statusfile, errfile
	statusfile, errfile = pcall(function() -- check if file exists
		f = io.open(fname)
		io.close(f)
	end)
	return (errfile == nil)
end

function reInit()
	Debug.clear()
	Debug.OFF()
	startList = 0
	selected = 0
	exeFile = ""
	files = System.listDirectory(System.currentDirectory())
end

function drawList(dirname)
	files = System.listDirectory(dirname)
	y = 0
	i = 0
	nbFiles = 0
	for k, file in pairs(files) do
		if i >= startList and i <= startList + 24 then
			y = y + 8
			if file.isDir then
				color = dirnamecolor -- directory
			else
				color = filenamecolor-- file
			end
			if i == selected then
				color = selectcolor -- select
				selectedFile = file
			end
			if file.isDir then
				screen.print(SCREEN_DOWN, 8, y, "["..file.name.."]", color)
			else
				screen.print(SCREEN_DOWN, 8, y, " "..file.name, color)
				if string.lower(string.sub(file.name, -4)) == ".lua" then
					screen.print(SCREEN_DOWN, 0, y, "*", color)
				end
			end
		end
		i = i + 1
		nbFiles = nbFiles + 1
	end

end

startList = 0
selected = 0
exeFile = ""

function goDown()
	if selected < nbFiles-1 then selected = selected + 1 end
	if selected - startList == 23 then startList = startList + 1 end
end

function goUp()
	if selected > 0 then selected = selected - 1 end
	if selected - startList == -1 then startList = startList - 1 end
end

while true do

	Controls.read()
	if Stylus.held then
		if math.floor(Stylus.Y / 8 - 1) <= nbFiles - 1 then
			selected = math.floor(Stylus.Y / 8 - 1)
		end
	end
	if Keys.newPress.Down or Stylus.deltaY > 1 then goDown() end
	if Keys.newPress.Up or Stylus.deltaY < -1 then goUp() end
	if Keys.newPress.R then for i=0, 14 do goDown() end end
	if Keys.newPress.L then for i=0, 14 do goUp() end end
	if Keys.newPress.Left then
		System.changeDirectory("..") 
		selected = 0
		startList = 0
	end
	if (Keys.newPress.A or Keys.newPress.Start or Stylus.doubleClick) then
		if string.lower(string.sub(selectedFile.name, -4)) == ".lua" then -- launch lua script
			exeFile = selectedFile.name
		else
			if selectedFile.isDir and fileExists(selectedFile.name.."/index.lua") then -- launch directory/index.lua script
				System.changeDirectory(selectedFile.name)
				exeFile = "index.lua"
			end
		end
	end	
	if (Keys.newPress.Right or Stylus.doubleClick) and selectedFile.isDir then 
		System.changeDirectory(selectedFile.name) 
		selected = 0
		startList = 0
	end
	
	screen.drawFillRect(SCREEN_UP, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, bgupcolor)
	screen.drawFillRect(SCREEN_DOWN, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, bgdowncolor)

	drawList(System.currentDirectory())
	screen.print(SCREEN_UP, 0, 184, (selected + 1).."/"..nbFiles, fgupcolor)
	str = "Micro LUA DS "..MICROLUA_VERSION
	screen.print(SCREEN_UP, (SCREEN_WIDTH / 2) - (8 * str:len() / 2), 32, str, microluacolor)
	str = "(c) Risike 2009  and community 2009 - 2011"
	screen.print(SCREEN_UP, (SCREEN_WIDTH / 2) - (8 * str:len() / 2), 56, "By Risike", fgupcolor)
	screen.print(SCREEN_UP, 8, 90, " dir: "..System.currentDirectory(), fgupcolor)
	screen.print(SCREEN_UP, 8, 106, "file: "..selectedFile.name, fgupcolor)
	screen.print(SCREEN_UP, 8, 144, "Move stylus up and down to navigate", fgupcolor)
	screen.print(SCREEN_UP, 8, 152, "Stylus double click: launch", fgupcolor)
	screen.print(SCREEN_UP, 8, 160, "Up, Down, Left, Right: navigate", fgupcolor)
	screen.print(SCREEN_UP, 8, 168, "A or Start: launch", fgupcolor)

	render()

	if exeFile ~= "" then
		dofile(System.currentDirectory()..exeFile) 
		reInit()
	end

end
