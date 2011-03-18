-- ##### CONST  ######

MICROLUA_VERSION = "3.0"
	
SCREEN_WIDTH = 256
SCREEN_HEIGHT = 192

RAM = 0
VRAM = 1

SCREEN_UP = 1
SCREEN_DOWN = 0
--SCREEN_BOTH = 2

ALPHA_RESET = 100

ATTR_X1 = 0
ATTR_Y1 = 1
ATTR_X2 = 2
ATTR_Y2 = 3
ATTR_X3 = 4
ATTR_Y3 = 5
ATTR_COLOR = 6
ATTR_COLOR1 = 7
ATTR_COLOR2 = 8
ATTR_COLOR3 = 9
ATTR_COLOR4 = 10
ATTR_TEXT = 11
ATTR_VISIBLE = 12
ATTR_FONT = 13
ATTR_IMAGE = 14

PLAY_LOOP = 0
PLAY_ONCE = 1

screen.setSpaceBetweenScreens(10)

mustCountFPS = true

startDrawing = function()
	screen.startDrawing2D()
end

stopDrawing = function()
	-- Count FPS
	if mustCountFPS then 
		NB_FPS_COUNTER = NB_FPS_COUNTER + 1
		mustCountFPS = false
	else
		mustCountFPS = true
	end
	if tmrFpsCounter:time() >= 1000 then
		NB_FPS = NB_FPS_COUNTER
		NB_FPS_COUNTER = 0
		tmrFpsCounter:reset()
		tmrFpsCounter:start()
	end
	-- Draw debug console
	if Debug.isDebugOn then
		screen.drawTextBox(SCREEN_DOWN, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, Debug.debugText, Debug.debugColor)
	end
	screen.endDrawing()
	screen.waitForVBL()		
end

render = function()
	stopDrawing()
	startDrawing()
end

Controls = {}

Stylus = {}
Stylus.X = -1
Stylus.Y = -1
Stylus.held = false
Stylus.released = false
Stylus.doubleClick = false
Stylus.deltaX = -1
Stylus.deltaY = -1
Stylus.newPress = false

Keys = {}
Keys.held = {}
Keys.released = {}
Keys.newPress = {}

Controls.read = function()
	ds_controls.read()
	Stylus.X = ds_controls.stylusX()
	Stylus.Y = ds_controls.stylusY()
	if not Stylus.held and ds_controls.stylusHeld() then Stylus.newPress = true else Stylus.newPress = false end
	Stylus.held = ds_controls.stylusHeld()
	Stylus.released = ds_controls.stylusReleased()
	Stylus.doubleClick = ds_controls.stylusDoubleClick()
	Stylus.deltaX = ds_controls.stylusDeltaX()
	Stylus.deltaY = ds_controls.stylusDeltaY()		
	if not Keys.held.A and ds_controls.heldA() then Keys.newPress.A = true else Keys.newPress.A = false end
	if not Keys.held.B and ds_controls.heldB() then Keys.newPress.B = true else Keys.newPress.B = false end
	if not Keys.held.X and ds_controls.heldX() then Keys.newPress.X = true else Keys.newPress.X = false end
	if not Keys.held.Y and ds_controls.heldY() then Keys.newPress.Y = true else Keys.newPress.Y = false end
	if not Keys.held.L and ds_controls.heldL() then Keys.newPress.L = true else Keys.newPress.L = false end
	if not Keys.held.R and ds_controls.heldR() then Keys.newPress.R = true else Keys.newPress.R = false end
	if not Keys.held.Start and ds_controls.heldStart() then Keys.newPress.Start = true else Keys.newPress.Start = false end
	if not Keys.held.Select and ds_controls.heldSelect() then Keys.newPress.Select = true else Keys.newPress.Select = false end
	if not Keys.held.Up and ds_controls.heldUp() then Keys.newPress.Up = true else Keys.newPress.Up = false end
	if not Keys.held.Down and ds_controls.heldDown() then Keys.newPress.Down = true else Keys.newPress.Down = false end
	if not Keys.held.Left and ds_controls.heldLeft() then Keys.newPress.Left = true else Keys.newPress.Left = false end
	if not Keys.held.Right and ds_controls.heldRight() then Keys.newPress.Right = true else Keys.newPress.Right = false end
	Keys.held.A = ds_controls.heldA()
	Keys.held.B = ds_controls.heldB()
	Keys.held.X = ds_controls.heldX()
	Keys.held.Y = ds_controls.heldY()
	Keys.held.Start = ds_controls.heldStart()
	Keys.held.Select = ds_controls.heldSelect()
	Keys.held.L = ds_controls.heldL()
	Keys.held.R = ds_controls.heldR()
	Keys.held.Up = ds_controls.heldUp()
	Keys.held.Down = ds_controls.heldDown()
	Keys.held.Left = ds_controls.heldLeft()
	Keys.held.Right  = ds_controls.heldRight()
	Keys.released.A = not ds_controls.heldA()
	Keys.released.B = not ds_controls.heldB()
	Keys.released.X = not ds_controls.heldX()
	Keys.released.Y = not ds_controls.heldY()
	Keys.released.Start = not ds_controls.heldStart()
	Keys.released.Select = not ds_controls.heldSelect()
	Keys.released.L = not ds_controls.heldL()
	Keys.released.R = not ds_controls.heldR()
	Keys.released.Up = not ds_controls.heldUp()
	Keys.released.Down = not ds_controls.heldDown()
	Keys.released.Left = not ds_controls.heldLeft()
	Keys.released.Right  = not ds_controls.heldRight()
end


Timer = {
	new = function()
		local t = os.time()
		local isStarted = false
		local tick = 0
	
		local time = function(self)
			if isStarted then return os.time() - t
			else return tick end
		end
	
		local stop = function(self)
			if isStarted then
				isStarted = false
				tick = os.time() - t
			end
		end
		
		local start = function(self)
			if not isStarted then
				isStarted = true
				t = os.time() - tick 	
			end
		end
		
		local reset = function(self)
			t = os.time()
			isStarted = false
			tick = 0				
		end
	
		return{
			time = time,
			stop = stop,
			start = start,
			reset = reset
		}
	end
}


Debug = {}
Debug.isDebugOn = false
Debug.debugText = ""
Debug.debugColor = Color.new(31, 31, 31)
Debug.ON = function()
	Debug.isDebugOn = true
end
Debug.OFF = function()
	Debug.isDebugOn = false
end
Debug.print = function(text)
	assert(text ~= nil, "Text can't be null")
	Debug.debugText = Debug.debugText..text.."\n"
end
Debug.setColor = function(color)
	assert(color ~= nil, "Color can't be null")
	Debug.debugColor = color
end
Debug.clear = function()
	Debug.debugText = ""
end

System = {}

System.currentDirectory = function() return ds_system.currentDirectory() end
System.changeDirectory = function(dir)
	assert(dir ~= nil, "Directory name can't be null")
	ds_system.changeCurrentDirectory(dir)
end
System.remove = function(file)
	assert(file ~= nil, "Parameter must be a file name or a directory name")
	ds_system.remove(file)
end	
System.rename = function(file1, file2)
	assert(file1 ~= nil, "Parameters 1 must be a file name or a directory name")
	assert(file2 ~= nil, "Parameters 2 must be a file name or a directory name")
	ds_system.rename(file1, file2)
end
System.makeDirectory = function(dir)
	assert(dir ~= nil, "Parameter must be a directory name")
	ds_system.makeDirectory(dir)
end
System.listDirectory = function(dir)
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
	for key, value in pairs(tabDir) do table.insert(tab, value) end
	for key, value in pairs(tabFile) do table.insert(tab, value) end
	tabDir = nil
	tabFile = nil
	return tab
end

DateTime = {}

DateTime.new = function()
	local year, month, day, hour, minute, second
	return {year = year, month = month, day = day, hour = hour, minute = minute, second = second}
end

DateTime.getCurrentTime = function()
	local dt = DateTime.new()
	dt.year = ds_system.getCurrentTime(0)
	dt.month = ds_system.getCurrentTime(1)
	dt.day = ds_system.getCurrentTime(2)
	dt.hour = ds_system.getCurrentTime(3)
	dt.minute = ds_system.getCurrentTime(4)
	dt.second = ds_system.getCurrentTime(5)
	return dt
end

-- Declaration of the Sprite class
Sprite = {

	-- path: path of the file which contains the sprite
	-- height: height of the frames
	-- width: width of the frames
	-- dest: destination (RAM or VRAM)
	new = function(path_, width_, height_, dest)
		assert(path_ ~= nil, "Path can't be null")
		assert(width_ > 0, "Width must be positive")
		assert(height_ > 0, "Height must be positive")
		assert(dest == RAM or dest == VRAM, "Destination must be RAM or VRAM")
		local path = path_
		local height = height_
		local width = width_
		local img = Image.load(path, dest)
		local animations = {}
		
		-- ### Public methods ###
		
		-- Draw a frame
		-- scr: screen (SCREEN_UP or SCREEN_DOWN)
		-- x: X-coordinate where to draw the frame
		-- y: Y-coordinate where to draw the frame
		-- noFrame: number of the frame to draw
		local drawFrame = function(self, scr, x, y, noFrame)
			assert(scr == SCREEN_UP or scr == SCREEN_DOWN or scr == SCREEN_BOTH, "Bad screen number")
			assert(x ~= nil, "X can't be null")
			assert(y ~= nil, "Y can't be null")
			assert(noFrame ~= nil, "Frame number can't be null")
			boardWidth = Image.width(img) / width
			yy = math.floor(noFrame / boardWidth)
			xx = noFrame - (yy * boardWidth)
			screen.blit(scr, x, y, img, xx*width, yy*height, width, height)
		end
		
		-- Create an animation
		-- tabAnim: the table of the animation frames
		-- delay: delay between each frame
		local addAnimation = function(self, tabAnim, delay)
			assert(tabAnim ~= nil, "Table can't be null")
			assert(delay >= 0, "Delay  must be positive")
			tmp = SpriteAnimation.new(tabAnim,delay)
			table.insert(animations, tmp)
		end
		
		-- Reset an animation
		-- noAnim: number of the animation
		local resetAnimation = function(self, noAnim)
			assert(noAnim > 0, "Animation number must be 1 or more")
			animations[noAnim].tmr:reset()
		end
		
		-- Start an animation
		-- noAnim: number of the animation
		local startAnimation = function(self, noAnim)
			assert(noAnim > 0, "Animation number must be 1 or more")
			animations[noAnim].tmr:start()
		end
		
		-- Stop an animation
		-- noAnim: number of the animation
		local stopAnimation = function(self, noAnim)
			assert(noAnim > 0, "Animation number must be 1 or more")
			animations[noAnim].tmr:stop()
		end
		
		-- Return true if the animation is at the end of a loop
		-- noAnim: number of the animation
		local isAnimationAtEnd = function(self, noAnim)
			assert(noAnim > 0, "Animation number must be 1 or more")
			return math.floor(animations[noAnim].tmr:time()/animations[noAnim].delay+1) >= table.getn(animations[noAnim].tabAnim)
		end
		
		-- Play an animation
		-- scr: screen (SCREEN_UP or SCREEN_DOWN)
		-- x: X-coordinate where to draw the animation
		-- y: Y-coordinate where to draw the animation
		-- noAnim: number of the animation to draw
		local playAnimation = function(self, scr, x, y, noAnim)
			assert(scr == SCREEN_UP or scr == SCREEN_DOWN or scr == SCREEN_BOTH, "Bad screen number")
			assert(x ~= nil, "X can't be null")
			assert(y ~= nil, "Y can't be null")
			assert(noAnim > 0, "Animation number must be 1 or more")
			if not animations[noAnim].isPlayed then
				animations[noAnim].tmr:reset()
				animations[noAnim].tmr:start()
				animations[noAnim].isPlayed = true
			end
			if math.floor(animations[noAnim].tmr:time()/animations[noAnim].delay) >= table.getn(animations[noAnim].tabAnim) then
				resetAnimation(self, noAnim)
				startAnimation(self, noAnim)
			end
			animToDraw = animations[noAnim].tabAnim[math.floor(animations[noAnim].tmr:time()/animations[noAnim].delay)+1]
			if animToDraw ~= nil then
				drawFrame(self, scr, x, y, animToDraw)
			end
		end
		
		local getWidth = function(self)
			return width
		end
		
		local getHeight = function(self)
			return height
		end
		
		local destroy = function(self)
			local key, value
			for key, value in pairs(animations) do
				value = nil
			end
			Image.destroy(img)
			img = nil
		end
		
		-- ### Returns ###
		
		return {
			path = path,
			getWidth = getWidth,
			getHeight = getHeight,
			drawFrame = drawFrame,
			addAnimation = addAnimation,
			playAnimation = playAnimation,
			resetAnimation = resetAnimation,
			stopAnimation = stopAnimation,
			startAnimation = startAnimation,
			isAnimationAtEnd = isAnimationAtEnd,
			destroy = destroy
		}

	end

}

-- Declaration of the SpriteAnimation class
SpriteAnimation = {

	-- tabAnim: the table of the animation frames
	-- delay: delay between each frame
	new = function(tabAnim_, delay_)			
			local tabAnim = tabAnim_
			local delay = delay_
			local tmr = Timer.new()
			local isPlayed = false
			return {
				tabAnim = tabAnim,
				delay = delay,
				tmr = tmr,
				isPlayed = isPlayed
			}
	end
	
}

str = "/lua/libs/"
dofile(str.."ini.lua")

-- ################################ START ################################

screen.init()

NB_FPS = 30
NB_FPS_COUNTER = 0
tmrFpsCounter = Timer.new()
tmrFpsCounter:start()

startDrawing()

while true do

	status_global_microlua_errors, err_global_microlua_errors = pcall(function ()
	    str = "/lua/libs/"
		dofile(str.."shell.lua")
	end)
	if err_global_microlua_errors ~= nil then
		Debug.OFF()	
		Controls.read()
		while not Keys.newPress.Start do
			Controls.read()
			screen.drawFillRect(SCREEN_UP, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, Color.new(0, 0, 31))
			screen.drawFillRect(SCREEN_DOWN, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, Color.new(0, 0, 31))
			screen.drawTextBox(SCREEN_DOWN, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, "*** ERRORS OCCURED ***\n"..err_global_microlua_errors.."\n"..debug.traceback().."\n*********************\n\nPress START to continue")
			render()
		end
	end

end




