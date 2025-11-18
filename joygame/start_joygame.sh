#!/usr/bin/env bash
set -ue

# 可以在config.lua中读取到环境变量,$ROOT、$DAEMON
export ROOT=$(cd "$(dirname ${0})" || exit; pwd)
export DAEMON=false

if [ ! -d "log" ]; then
    mkdir log
fi

if [ $(ps aux | grep -v grep | grep $(pwd) | grep -c skynet) != 0 ]; then
    echo "server is already running, please execute ./stop.sh"
else
    $ROOT/skynet/skynet $ROOT/config/standalone.lua
fi
