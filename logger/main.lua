local skynet = require "skynet"

local args = {...}

local function logger()
    while true do
        skynet.error("Hello Logger")
        skynet.sleep(100)
    end
end

skynet.start(function()
    skynet.error(type(args))
    for key, value in pairs(args) do
        skynet.error("param", key, value)
    end
    skynet.fork(logger)
    while true do
        skynet.error("Hello Skynet")
        skynet.sleep(100)
    end
end)