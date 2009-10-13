font = Font.load("forte.bin")

while not Keys.newPress.Start do

	Controls.read()

	startDrawing()
	
	screen.print(SCREEN_UP, 0, 0, "Press START to quit")
	screen.print(SCREEN_DOWN, 0, 0, "This is default font")
	Font.print(SCREEN_DOWN, font, 0, 36, "This is custom font", Color.new(31, 31, 0))
	
	stopDrawing()

end

Font.destroy(font)
font = nil
