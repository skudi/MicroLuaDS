--[[

        ==>[ MICROLUA EXAMPLE ]<==
               ==>{ Current time }<==
        
            About making a pretty clock.

]]--

while not Keys.newPress.Start do
	Controls.read()

	now = DateTime.getCurrentTime()                         -- Get the curent time at each frame

	screen.print(SCREEN_UP, 0, 0, "Press START to quit")
    -- Display and format the time
	screen.print(SCREEN_DOWN, 0, 0, "We are "..now.year.."/"..now.month.."/"..now.day..", and it's "..now.hour..":"..now.minute..":"..now.second)

	render()
end
