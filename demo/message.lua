-- 创建一个skynet服务
local skynet = require "skynet"

require "skynet.manager"

local params = { ... }

local function handle(session, address, ...)
    skynet.error("session", session)
    skynet.error("address", skynet.address(address))
    local args = { ... }
    for i, v in pairs(args) do
        skynet.error("arg" .. i .. ":", v)
    end
    return skynet.retpack("test", 123)
end

local function entry()
    skynet.error(SERVICE_NAME .. " is running.")
    skynet.dispatch("lua", handle)
    skynet.register(".luamsg")

    for i, v in pairs(params) do
        skynet.error("params:", i, v)
    end
end

-- 可以自定义消息的解析方式
skynet.register_protocol({
    name = "system",
    id = skynet.PTYPE_SYSTEM,
    pack = skynet.pack,
    unpack = skynet.unpack
})

-- 调用skynet.start接口，并定义传入回调函数处理业务
skynet.start(entry)
