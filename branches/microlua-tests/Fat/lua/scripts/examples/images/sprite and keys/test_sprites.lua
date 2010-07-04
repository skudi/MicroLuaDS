spr = Sprite.new("sprite.png", 24, 32, VRAM)

spr:addAnimation({0,1,2,1}, 300) -- Walk up
spr:addAnimation({3,4,5,4}, 300) -- Walk right
spr:addAnimation({6,7,8,7}, 300) -- Walk down
spr:addAnimation({9,10,11,10}, 300) -- Walk left

x = 150
y = 80
direction = 1


while not Keys.newPress.Start do

	Controls.read()

	startDrawing()

	spr:playAnimation(SCREEN_DOWN, x, y, direction)

	if Keys.held.Up then direction = 1 y = y - 1 end
	if Keys.held.Right then direction = 2 x = x + 1 end
	if Keys.held.Down then direction = 3 y = y + 1 end
	if Keys.held.Left then direction = 4 x = x - 1 end

	screen.print(SCREEN_UP, 0, 184, "FPS: "..NB_FPS)
	screen.print(SCREEN_UP, 0, 0, "Press START to quit")

	stopDrawing()

end

spr:destroy()
spr = nil
x = nil
y = nil
direction = nil

