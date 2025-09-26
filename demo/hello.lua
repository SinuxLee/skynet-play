-- 创建一个skynet服务
local skynet = require "skynet"

-- 调用skynet.start接口，并定义传入回调函数处理业务
skynet.start(
    function()
        skynet.error(SERVICE_NAME.." is running.")
    end
)
