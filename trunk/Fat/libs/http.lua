HTTPRequest = {}

HTTP_POST = "POST"
HTTP_GET = "GET"
HTTP_RECEIVE_PACKET_SIZE = 1024

HTTPRequest.new = function(method_, host_, port_)
    assert(method_ == HTTP_POST or method_ == HTTP_GET,
           "Method must be HTTP_POST or HTTP_GET")
    assert(host_ ~= nil and host_ ~= "", "Invalid host")
    if port_ == nil then port_ = 80 end
    local method = method_
    local host = host_
    local port = port_

    local download = function(self, path, file, params)
        if file == nil then file = "/" end
        if params == nil then params = "" end
        local socket = Wifi.createTCPSocket(host, port)
        local request = method.." "..file.." HTTP/1.1\r\n"
        local buffer, i
        request = request.."Host: "..host.."\r\n"
        request = request.."Accept: */*\r\nAccept-Ranges: bytes\r\nConnection: Keep-Alive\r\n"
        request = request.."Content-type: application/x-www-form-urlencoded\r\n"
        request = request.."Content-Length: "..params:len().."\r\n\r\n"
        request = request..params
        Wifi.send(socket, request)
        f = io.open(path, "wb")
        buffer = "0"
        while buffer ~= nil 0 do
            buffer = Wifi.receive(socket, HTTP_RECEIVE_PACKET_SIZE)
            if buffer ~= nil then
                for i=1, buffer:len() do
                    f:write(tonumber(string.byte(buffer:sub(i, i))))
                end
            end
        end
        Wifi.closeSocket(socket)
        socket = nil
        f:close()
    end

    return {
        download = download,
    }

end

Wifi.connectWFC()

http = HTTPRequest.new(HTTP_GET, "www.microlua.risike.com")
http:download("test", "/zfiles/0.png")



while true do
    screen.print(SCREEN_UP, 0, 0, "ok")
    render()
end

