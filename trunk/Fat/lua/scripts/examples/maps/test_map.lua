img = Image.load("tiles.png", VRAM)
map = Map.new(img, "map.map", 15, 15, 32, 32)

scrollX = 0
scrollY = 0

Map.setTile(map, 0, 0, 0) -- to test setTile

while not Keys.newPress.Start do

	Controls.read()
	
	if Keys.held.Up then scrollY = scrollY - 1 end
	if Keys.held.Down then scrollY = scrollY + 1 end
	if Keys.held.Left then scrollX = scrollX - 1 end
	if Keys.held.Right then scrollX = scrollX + 1 end
	
	Map.scroll(map, scrollX, scrollY)

	startDrawing()
	
	Map.draw(SCREEN_DOWN, map, 10, 10, 5, 5)
	screen.print(SCREEN_UP, 0, 0, "+ to scroll")
	screen.print(SCREEN_UP, 0, 16, "Press START to quit")
	screen.print(SCREEN_DOWN, 0, 184, "FPS: "..NB_FPS)
	
	stopDrawing()


end

img = Image.destroy(img)
img = nil
map = Map.destroy(map)
map = nil
scrollX = nil
scrollY = nil

