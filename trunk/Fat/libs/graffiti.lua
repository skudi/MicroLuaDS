Graffiti = {}

Graffiti.start = function()
    Graffiti.canvas = Canvas.new()
    Graffiti.x = nil
    Graffiti.y = nil
    Graffiti.points = {}
    Graffiti.chars = {}
    table.insert(Graffiti.chars, {char="A", value="&&&&&&&////////", match=0})
    table.insert(Graffiti.chars, {char="B", value="#&&&$#%'$$)+'&&", match=0})
    table.insert(Graffiti.chars, {char="C", value=".+'%$$%%'),/366", match=0})
end

Graffiti.stop = function()
    Canvas.destroy(Graffiti.canvas)
end

Graffiti._scanPoints = function()
    local i, point, pChar, pX, pY, step, best, bestValue, matchDiff, nb, pCharValue
    step = math.floor(table.getn(Graffiti.points) / 15)
    nb = 1
    textChar = ""
    for i = 1, table.getn(Graffiti.points), step do
        point = Graffiti.points[i]
        if point == nil then break end
        pX = math.floor(((point.x - Graffiti.minX) * 15) / Graffiti.maxX)
        pY = math.floor(((point.y - Graffiti.minY) * 15) / Graffiti.maxY)
        pCharValue = pX * 4 + pY
        pCharValue = math.floor((pCharValue * 90) / (255)) + 35
        pChar = string.char(pCharValue)
        textChar = textChar..pChar
        for j = 1, table.getn(Graffiti.chars) do
            Graffiti.chars[j].match = 0
        end
        best = 0
        bestValue = 999
        for j = 1, table.getn(Graffiti.chars) do
            if nb > 15 then nb = 15 end
            matchDiff = math.abs(string.byte(pChar) - string.byte(Graffiti.chars[j].value:sub(nb, nb)))
            if matchDiff < bestValue then
                best = j
                bestValue = matchDiff
            end
        end
        Graffiti.chars[best].match = Graffiti.chars[best].match + 1
        nb = nb + 1
        if nb > 15 then break end
    end
    bestValue = 0
    best = 0
    for j = 1, table.getn(Graffiti.chars) do
        if Graffiti.chars[j].match > bestValue then
            best = j
            bestValue = Graffiti.chars[j].match
        end
    end
    Debug.print(textChar)
    txt = ""
    for i=1, 3 do
        txt = txt.."-"..Graffiti.chars[i].match
    end
    error(txt)
    return Graffiti.chars[best].char
end

Graffiti.getChar = function()
    assert(table.getn(Graffiti.chars) > 0, "No characters to match")
    local line, point, x, y
    if Graffiti.canvas ~= nil then
        Canvas.draw(SCREEN_DOWN, Graffiti.canvas, 0, 0)
    end
    if Stylus.released then
        Canvas.destroy(Graffiti.canvas)
        Graffiti.canvas = nil
        return Graffiti._scanPoints()
    end
    if Stylus.newPress then
        Graffiti.canvas = Canvas.new()
        Graffiti.x = Stylus.X
        Graffiti.y = Stylus.Y
        point = {}
        point.x = Graffiti.x
        point.y = Graffiti.y
        Graffiti.points = {}
        table.insert(Graffiti.points, point)
        Graffiti.minX = point.x
        Graffiti.maxX = point.x
        Graffiti.minY = point.y
        Graffiti.maxY = point.y
    else
        if Stylus.held then
            if Graffiti.x ~= nil and Graffiti.y ~= nil and Graffiti.canvas ~= nil then
                line  = Canvas.newLine(Graffiti.x, Graffiti.y, Stylus.X, Stylus.Y,
                                       Color.new(31, 31, 31))
                Canvas.add(Graffiti.canvas, line)
            end
            Graffiti.x = Stylus.X
            Graffiti.y = Stylus.Y
            point = {}
            point.x = Graffiti.x
            point.y = Graffiti.y
            table.insert(Graffiti.points, point)
            if point.x < Graffiti.minX then Graffiti.minX = point.x end
            if point.x > Graffiti.maxX then Graffiti.maxX = point.x end
            if point.y < Graffiti.minY then Graffiti.minY = point.y end
            if point.y > Graffiti.maxY then Graffiti.maxY = point.y end

        end
    end
    return ""
end

Debug.ON()

Graffiti.start()

text = ""

while true do
    Controls.read()
    text = text..Graffiti.getChar()
    screen.print(SCREEN_UP, 0, 0, text)
    render()
end

