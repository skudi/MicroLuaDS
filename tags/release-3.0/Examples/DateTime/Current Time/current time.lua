while not Keys.newPress.Start do

	Controls.read()

	now = DateTime.getCurrentTime() -- To refresh in each frame

	screen.print(SCREEN_UP, 0, 0, "Press START to quit")
	screen.print(SCREEN_DOWN, 0, 0, "We are "..now.year.."/"..now.month.."/"..now.day..", and it's "..now.hour..":"..now.minute..":"..now.second)

	render()

end
