Debug.ON()

a = 10
b = 15

Debug.print("This is debug lines :")
Debug.print("a = "..a)
Debug.print("b = "..b)
Debug.print("a+b = "..a+b)
Debug.print("Press START to quit")

while not Keys.newPress.Start do

	Controls.read()

	startDrawing()
	stopDrawing()

end

a = nil
b = nil
