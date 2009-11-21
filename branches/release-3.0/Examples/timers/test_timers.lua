tmr = Timer.new()
tmr:start()

while not Keys.newPress.Start do

	Controls.read()
	if Keys.newPress.A then tmr:stop() end
	if Keys.newPress.B then tmr:start() end
	if Keys.newPress.X then tmr:reset() end

	startDrawing()

	time = tmr:time()
	hour = math.floor(time/3600000)
	rest = time % 3600000
	minut = math.floor(time/60000)
	rest = rest % 60000
	second = math.floor(rest/1000)
	rest = rest % 1000
	milli = rest
	
	screen.print(SCREEN_UP, 0, 0, "A: stop")
	screen.print(SCREEN_UP, 0, 8, "B: start")
	screen.print(SCREEN_UP, 0, 16, "X: reset")
	screen.print(SCREEN_UP, 0, 24, "Start: quit")
	screen.print(SCREEN_DOWN, 50, 50, ""..hour..":"..minut..":"..second..":"..milli)

	stopDrawing()

end

tmr = nil
time = nil
rest = nil
minut = nil
second = nil
milli = nil

