local skynet = require "skynet"

local max_client = 5000
local console_port = 8888
local gate_port = 8001

local function entry()
    skynet.error(SERVICE_NAME .. " service starting")

    skynet.uniqueservice("protoloader")

    -- 终端调试
    if not skynet.getenv "daemon" then
        skynet.newservice("console")
    end
    skynet.newservice("debug_console", console_port)

    -- 对客户端的网络
    local watchdog = skynet.newservice("watchdog")
    skynet.call(watchdog, "lua", "start", {
        port = gate_port,
        maxclient = max_client,
        nodelay = true,
    })
    skynet.error("gated listen on", gate_port)

    skynet.exit()
end

skynet.start(entry)
