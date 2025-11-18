root = "$ROOT/"
luaservice = root .. "skynet/service/?.lua;" .. root .. "?.lua;"
luaservice = luaservice .. root .. "gate/?.lua;" .. root .. "gate/?/init.lua;"
luaservice = luaservice .. root .. "db/?.lua;" .. root .. "db/?/init.lua;"
snax = root .. "gate/?.lua"
lualoader = root .. "skynet/lualib/loader.lua"
lua_path = root .. "skynet/lualib/?.lua;" .. root .. "skynet/lualib/?/init.lua;" .. root .. "?.lua"
lua_cpath = root .. "skynet/luaclib/?.so"
cpath = root .. "skynet/cservice/?.so"

thread = 4
logger = nil -- root.."logs/skynet.log"
logpath = "."

harbor = 0
bootstrap = "snlua bootstrap"
start = "standalone"
