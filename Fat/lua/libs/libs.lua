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
		local buffer="FPS: "..NB_FPS
		local xx=255-(string.len(buffer)*6)
		screen.print(SCREEN_UP,171,162,"RAM : "..math.floor(collectgarbage("count")).."o.",Debug.debugColor)
		screen.print(SCREEN_UP,171,172,"VRAM: "..System.CurrentVramFree().."o.",Debug.debugColor)
		screen.print(SCREEN_UP,171,182,"FPS : "..NB_FPS,Debug.debugColor)
		screen.drawTextBox(SCREEN_DOWN, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, Debug.debugText, Debug.debugColor)
	end
    screen.setAlpha(ALPHA_RESET)
	screen.endDrawing()
	screen.waitForVBL()		
end

render = function()
	stopDrawing()
	startDrawing()
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
Debug.listText = {}
Debug.debugText = ""
Debug.debugColor = Color.new(31, 31, 31)
Debug.ON = function()
	Debug.isDebugOn = true
	Debug.clear()
end
Debug.OFF = function()
	Debug.isDebugOn = false
end
Debug.print = function(text,aff)
	local i
	--assert(text ~= nil, "Text can't be null")
	if(text == nil) then text = "<nil>"
	elseif(text == true) then text = "TRUE"
	elseif(text == false) then text = "FALSE"
	elseif(type(text) == "table") then text = "<"..tostring(text).."["..table.maxn(text).."]>"
	elseif(type(text) == "userdata") then text = "<"..tostring(text)..">"
	elseif(type(text) == "function") then text = "<"..tostring(text)..">"
	elseif(type(text) == "thread") then text = "<"..tostring(text)..">"
	end
	if(aff ~= nil) then
		if(aff ~= true) then aff = false end
	end
	if(#Debug.listText == 21) then
		for i=1,20 do
			Debug.listText[i] = Debug.listText[i+1]
		end
		Debug.listText[21] = text
	else
		table.insert(Debug.listText,text)
	end
	Debug.debugText = ""
	for i = 1,#Debug.listText do
		Debug.debugText = Debug.debugText..Debug.listText[i].."\n"
	end
	if aff then render() end
end
Debug.setColor = function(color)
	assert(color ~= nil, "Color can't be null")
	Debug.debugColor = color
end
Debug.clear = function()
	local i
	for i = 1,#Debug.listText do
		table.remove(Debug.listText,1)
	end
end

-- Declaration of the Sprite class
Sprite = {

	-- path: path of the file which contains the sprite
	-- height: height of the frames
	-- width: width of the frames
	-- dest: destination (RAM or VRAM)
	new = function(graph_, width_, height_, dest)
		assert(path_ ~= nil, "Path can't be null")
		assert(width_ > 0, "Width must be positive")
		assert(height_ > 0, "Height must be positive")
		assert(dest == RAM or dest == VRAM, "Destination must be RAM or VRAM")
		local height = height_
		local width = width_
		if type(graph_) == "string" then
			local path = graph_
			local img = Image.load(path, dest)
		elseif type(graph_) == "userdata" then
			local img = graph_
			local path = "" -- I don't know why I write this ...
		end
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


dofile(ULUA_LIBS.."ini.lua")

-- ################################ START ################################

screen.init()

NB_FPS = 30
NB_FPS_COUNTER = 0
tmrFpsCounter = Timer.new()
tmrFpsCounter:start()

startDrawing()


while true do

	local func = function () dofile(ULUA_LIBS.."shell.lua") end
	status_global_microlua_errors, err_global_microlua_errors = pcall(func)
	if err_global_microlua_errors ~= nil then
		Debug.OFF()	
		Controls.read()
		while not Keys.newPress.Start do
			Controls.read()
			screen.drawFillRect(SCREEN_UP, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, Color.new(0, 0, 31))
			screen.drawTextBox(SCREEN_UP,0,0,SCREEN_WIDTH,SCREEN_HEIGHT,"**** DEBUG STACK ****\n"..Debug.debugText)
			screen.drawFillRect(SCREEN_DOWN, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, Color.new(0, 0, 31))
			screen.drawTextBox(SCREEN_DOWN, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, "*** ERRORS OCCURED ***\n"..err_global_microlua_errors.."\n"..debug.traceback().."\n*********************\n\nPress START to continue\n")
			render()
		end
	end

end
