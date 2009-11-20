assert(Rumble.isInserted(), "No rumble device inserted")

while not Keys.newPress.Start do

	Controls.read()
	
	if Keys.newPress.A then Rumble.set(true) end
	if Keys.newPress.B then Rumble.set(false) end

	screen.print(SCREEN_UP, 0, 0, "Press START to quit")
	screen.print(SCREEN_DOWN, 0, 0, "[A]: Rumble ON")
	screen.print(SCREEN_DOWN, 0, 8, "[B]: Rumble OFF")

	render()
	
end

