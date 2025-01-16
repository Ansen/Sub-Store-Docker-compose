#!/bin/sh

. /etc/profile

# 检查并设置环境变量， 可通过docker 传入
: "${SUB_STORE_FRONTEND_BACKEND_PATH:=/$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 18)}"
: "${SUB_STORE_BACKEND_SYNC_CRON:='55 23 * * *'}"


# 内置变量不建议修改，如果你不知道你在做什么的话

# frontend
SUB_STORE_FRONTEND_HOST=0.0.0.0
SUB_STORE_FRONTEND_PORT=3001
SUB_STORE_FRONTEND_PATH=/app/html
# backend
SUB_STORE_DATA_BASE_PATH=/db
SUB_STORE_BACKEND_API_HOST=0.0.0.0
SUB_STORE_BACKEND_API_PORT=3000

{
    echo "export SUB_STORE_FRONTEND_HOST=${SUB_STORE_FRONTEND_HOST}"
    echo "export SUB_STORE_FRONTEND_PORT=${SUB_STORE_FRONTEND_PORT}"
    echo "export SUB_STORE_FRONTEND_PATH=${SUB_STORE_FRONTEND_PATH}"
    echo "export SUB_STORE_FRONTEND_BACKEND_PATH=${SUB_STORE_FRONTEND_BACKEND_PATH}"
    echo "export SUB_STORE_BACKEND_SYNC_CRON=${SUB_STORE_BACKEND_SYNC_CRON}"
    echo "export SUB_STORE_DATA_BASE_PATH=${SUB_STORE_DATA_BASE_PATH}"
    echo "export SUB_STORE_BACKEND_API_HOST=${SUB_STORE_BACKEND_API_HOST}"
    echo "export SUB_STORE_BACKEND_API_PORT=${SUB_STORE_BACKEND_API_PORT}"
} > /app/.env

. /app/.env
supervisord -c /etc/supervisord.conf