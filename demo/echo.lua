local skynet = require "skynet"
local socket = require "skynet.socket"

--简单echo服务
local function echo(client_fd, remote_addr)
    socket.start(client_fd)
    while true do
        local str, endstr = socket.readline(client_fd)
        if str then
            skynet.error("recv " .. str)
            socket.write(client_fd, string.upper(str))
        else
            socket.close(client_fd)
            skynet.error(remote_addr .. " disconnect, endstr", endstr)
            return
        end
    end
end

local function accept(client_fd, remote_addr)
    skynet.error(remote_addr .. " accepted")
    skynet.fork(echo, client_fd, remote_addr) --来一个连接，就开一个新的协程来处理客户端数据
end

local function entry()
    local addr = "0.0.0.0:8001"
    skynet.error("listen " .. addr)
    local server_fd = socket.listen(addr)
    -- 或者local server_fd = socket.listen("0.0.0.0", 8001, 128)
    assert(server_fd)
    socket.start(server_fd, accept)
end

skynet.start(entry)
