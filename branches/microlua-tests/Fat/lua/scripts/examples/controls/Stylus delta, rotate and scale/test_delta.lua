img = Image.load("flag.png", VRAM)

angle = 0
anglePlus = 0
newWidth = Image.width(img)
newHeight = Image.height(img)

while not Keys.newPress.Start do

	Controls.read()

	startDrawing()
	screen.drawFillRect(SCREEN_DOWN, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, Color.new(31, 31, 31))
	screen.print(SCREEN_UP, 0, 0, "Move your stylus horizontally and")
	screen.print(SCREEN_UP, 0, 8, "release it quickly to move the flag")
	screen.print(SCREEN_UP, 0, 16, "Press R to zomm in")
	screen.print(SCREEN_UP, 0, 24, "Press L to zoom out")
	screen.print(SCREEN_UP, 0, 32, "Press START to quit")
	screen.print(SCREEN_UP, 0, 184, "FPS: "..NB_FPS)

	Image.rotateDegree(img, angle, Image.width(img)/2, Image.height(img)/2)
	
	if Keys.held.R then
		newWidth = newWidth + 2
		newHeight = newHeight + 2
		Image.scale(img, newWidth, newHeight)
	end
	if Keys.held.L then
		newWidth = newWidth - 2
		newHeight = newHeight - 2
		if newWidth < 1 then newWidth = 1 end
		if newHeight < 1 then newHeight = 1 end
		Image.scale(img, newWidth, newHeight)
	end	

	anglePlus = anglePlus - 1
	if anglePlus < 0 then anglePlus = 0 end
	angle = angle + anglePlus
	if angle > 360 then
		angle = angle - 360
	end

	if Stylus.deltaX > 0 then anglePlus = Stylus.deltaX end

	screen.blit(SCREEN_DOWN, 96, 64, img)

	stopDrawing()

end

Image.destroy(img)
img = nil
angle = nil
anglePlus = nil
newWidth = nil
newHeight = nil

