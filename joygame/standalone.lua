-- 单机部署，all in one

local skynet = require "skynet"

local function entry()
    skynet.error(SERVICE_NAME .. " service starting")
    skynet.newservice("gated")
    skynet.newservice("simpledb")
end

skynet.start(entry)
