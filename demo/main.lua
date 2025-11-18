local skynet = require "skynet"
local httpc = require "http.httpc"
local dns = require "skynet.dns"
local snax = require "skynet.snax"

require "skynet.manager"

skynet.register(".main")

local args = { ... }

local function request_baidu(protocol)
    --httpc.dns()	-- set dns server
    httpc.timeout = 100 -- set timeout 1 second
    print("GET baidu.com")
    protocol = protocol or "http"
    local respheader = {}
    local host = string.format("%s://baidu.com", protocol)
    print("geting... " .. host)
    local status, body = httpc.get(host, "/", respheader)
    print("[header] =====>")
    for k, v in pairs(respheader) do
        print(k, v)
    end
    print("[body] =====>", status)
    print(body)

    local respheader = {}
    local ip = dns.resolve "baidu.com"
    print(string.format("GET %s (baidu.com)", ip))
    local status, body = httpc.get(host, "/", respheader, { host = "baidu.com" })
    print(status)
end

local function http_client()
    dns.server()
    request_baidu("http")

    if not pcall(require, "ltls.c") then
        print "No ltls module, https is not supported"
    else
        request_baidu("https")
    end
end

local function timer()
    for i = 1, 100, 1 do
        local time = i % 5 * 100
        skynet.timeout(
            time,
            function()
                skynet.error(skynet.now(), coroutine.running())
            end
        )
    end
end

local function logger()
    while true do
        skynet.error("Hello Logger")
        skynet.sleep(100)
    end
end

local function entry()
    skynet.error("entry time:" .. skynet.now())
    local hello_handle = skynet.newservice("hello")       -- 启动新的 service, 普通服务不保证唯一性
    skynet.name(".hello", hello_handle)                   -- 给service定义别名，方便调用

    skynet.uniqueservice(true, "hello")                   -- 所有节点内是唯一的
    skynet.uniqueservice("hello")                         -- 此节点内是唯一的
    skynet.error(skynet.queryservice(true, "hello"), skynet.queryservice("hello"))
    skynet.error("entry file:" .. skynet.getenv("start")) -- 只能是config或者代码中定义的变量,可以新增加但无法修改。
    skynet.error("thread num:" .. skynet.getenv("thread"))

    -- notify
    skynet.newservice("message", "libz", "haha")
    local r = skynet.send(".luamsg", "lua", 1, "nengzhong", true)
    skynet.error("skynet.send return value:", r)

    -- request
    local ret = skynet.call(".luamsg", "lua", 1, "nengzhong", true)
    skynet.error("skynet.call return value:", ret)
    skynet.error("request finish")

    skynet.newservice("echo")

    snax.newservice("snax", "test snax") -- snax 是支持热更新的
end

-- 在 skynet.start 之前做一些初始化工作
skynet.init(
    function()
        skynet.error("handler:" .. skynet.self())
        skynet.error("str handler:" .. skynet.address(skynet.self()))
    end
)

-- start 函数只启动 service，并不处理主要业务。此处不允许有阻塞代码存在
skynet.start(
    function()
        -- skynet.fork(http_client)
        -- skynet.fork(timer)
        -- skynet.timeout(0, entry)
        -- skynet.exit() -- 显示说明退出 service
        -- skynet.abort() -- 退出整个进程
    end
)
