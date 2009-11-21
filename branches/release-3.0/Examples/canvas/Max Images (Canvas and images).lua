img = Image.load("image.png", VRAM)
canvas = Canvas.new()

nb = 0

while not Keys.held.Start do

	Controls.read()

	startDrawing()

	for i=1, 3 do
		nb = nb + 3
		obj = Canvas.newImage(math.random(-10, 240), math.random(-10, 180), img)
		Canvas.add(canvas, obj)
	end

	Canvas.draw(SCREEN_UP, canvas, 0, 0)
	screen.print(SCREEN_DOWN, 0, 0, "FPS: "..NB_FPS)
	screen.print(SCREEN_DOWN, 0, 8, "IMG: "..nb)
	screen.print(SCREEN_DOWN, 0, 50, "Press START to quit")

	stopDrawing()

end

Image.destroy(img)
img = nil
Canvas.destroy(canvas)
canvas = nil
nb = nil
