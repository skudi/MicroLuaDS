Window = {}

Window.isStylusInRectangle = function(x0, y0, x1, y1)
	local x = Stylus.X
	local y = Stylus.Y
	return (x >= x0 and x <= x1 and y >= y0 and y <= y1)
end

Window.new = function(_title, _width, _height)
	assert(_title ~= nil, "Title can't be nil")
	assert(_width >= 10, "Width must be >= 10")
	assert(_height >= 20, "Height must be >= 20")
	local title = _title
	local width = _width
	local height = _height
	local borderColor = Color.new(15, 15, 15)
	local backgroundColor = Color.new(31, 31, 31)
	local controls = {}
	local x = math.floor((SCREEN_WIDTH - width) / 2)
	local y = math.floor((SCREEN_HEIGHT - height) / 2)
	local borderWidth = 1
	local gradientColor1 = Color.new(0, 0, 31)
	local gradientColor2 = Color.new(31, 31, 31)
	local titleColor = Color.new(0, 0, 0)
	local closeColor = Color.new(31, 0, 0)
	local icon = nil
	local visible = true
	local movable = true
	local closable = true
	local _drag = false
	local _dragX = 0
	local _dragY = 0
	
	local draw = function(self)
		if not visible then return end
		
		-- Draw
		local key, value
		screen.drawFillRect(SCREEN_DOWN, x, y, x + width, y + height, borderColor)
		screen.drawFillRect(SCREEN_DOWN, x + borderWidth, y + borderWidth, x + width - borderWidth, y + height - borderWidth, backgroundColor)
		screen.drawGradientRect(SCREEN_DOWN, x + borderWidth, y + borderWidth, x + width - borderWidth, y + 10 - borderWidth, gradientColor1, gradientColor2, gradientColor1, gradientColor2)		
		if closable then
			screen.drawFillRect(SCREEN_DOWN, x + width - borderWidth - 8, y + borderWidth, x + width - borderWidth, y + borderWidth + 8, closeColor)
			screen.drawLine(SCREEN_DOWN, x + width - borderWidth - 7, y + borderWidth + 1, x + width - borderWidth - 1, y + borderWidth + 7, Color.new(31, 31, 31))
			screen.drawLine(SCREEN_DOWN, x + width - borderWidth - 1, y + borderWidth + 1, x + width - borderWidth - 7, y + borderWidth + 7, Color.new(31, 31, 31))
		end
		if icon == nil then			
			screen.print(SCREEN_DOWN, x + borderWidth + 2, y + borderWidth, title, titleColor)			
		else
			assert(Image.width(icon) ~= 8 and Image.height(icon) ~= 8, "Logo size must be 8x8 pixels max")
			screen.blit(SCREEN_DOWN, x + borderWidth, y + borderWidth, icon)
			screen.print(SCREEN_DOWN, x + borderWidth + 10, y + borderWidth, title, titleColor)		
		end
		for key, value in pairs(controls) do
			value:draw(x + borderWidth + 1, y + borderWidth + 9)
		end
		
		-- Controls
		if movable and not _drag and Stylus.newPress and Window.isStylusInRectangle(x + borderWidth, y + borderWidth, x + borderWidth + width, y + borderWidth + 8) then
			_drag = true
			_dragX = Stylus.X - x
			_dragY = Stylus.Y - y
		end
		if Stylus.released then
			_drag = false
		end
		if _drag and Stylus.held then			
			x = Stylus.X - _dragX
			y = Stylus.Y - _dragY
		end		
	end
	
	local addControl = function(self, control)
		table.insert(controls, control)
	end

	return{
		title = title,
		width = width,
		height = height,		
		borderColor = borderColor,
		backgroundColor = backgroundColor,
		controls = controls,
		x = x,
		y = y,
		borderWidth = borderWidth,
		gradientColor1 = gradientColor1,
		gradientColor2 = gradientColor2,
		titleColor = titleColor,
		closeColor = closeColor,
		icon = icon,
		visible = visible,
		movable = movable,
		closable = closable,
		
		draw = draw,
		addControl = addControl
	}
end

Label = {}

Label.new = function(_x, _y, _text, _font)
	assert(_x >= 0, "X must be > 0")
	assert(_y >= 0, "Y must be > 0")
	assert(_text ~= nil, "Text can't be null")
	local x = _x
	local y =_y
	local text = _text
	local font = _font
	local textColor = Color.new(0, 0, 0)
	local backgroundColor = nil
	local visible = true	
	
	local draw = function(self, baseX, baseY)
		if not visible then return end
		if font == nil then
			if backgroundColor ~= nil then
				screen.drawFillRect(SCREEN_DOWN, baseX + x, baseY + y, baseX + x + (6 * text:len()), baseY + y + 8, backgroundColor)
			end
			screen.print(SCREEN_DOWN, baseX + x, baseY + y, text, textColor)
		else
			if backgroundColor ~= nil then
				screen.drawFillRect(SCREEN_DOWN, baseX + x, baseY + y, baseX + x + Font.getStringWidth(font, text), baseY + y + Font.getCharHeight(font), backgroundColor)
			end
			screen.printFont(SCREEN_DOWN, baseX + x, baseY + y, text, textColor, font)
		end
	end

	return{
		x = x,
		y = y,
		text = text,
		font = font,
		textColor = textColor,
		backgroundColor = backgroundColor,
		visible = visible,		

		draw = draw
	}
end



win = Window.new("test", 100, 50)
lbl = Label.new(0, 0, "test label", Font.load("forte.bin"))
win:addControl(lbl)

while true do

	Controls.read()	
	
	win:draw()

	render()

end
