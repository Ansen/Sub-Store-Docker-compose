#!/bin/sh

. /etc/profile


NGINX_CONFIG='/etc/nginx/http.d/default.conf'

# 检查并设置环境变量， 可通过docker 传入
: "${SUB_STORE_FRONTEND_BACKEND_PATH:=/$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 18)}"
: "${SUB_STORE_BACKEND_SYNC_CRON:='55 23 * * *'}"

# 内置变量不建议修改，如果你不知道你在做什么的话
SUB_STORE_DATA_BASE_PATH=/db
SUB_STORE_BACKEND_API_HOST='127.0.0.1'
SUB_STORE_BACKEND_API_PORT=3001

if grep -q "SUB_STORE_FRONTEND_BACKEND_PATH" "${NGINX_CONFIG}"
then
    nginx_prefix_path=$(echo "${SUB_STORE_FRONTEND_BACKEND_PATH}" | tr -d '/')
    echo "update SUB_STORE_FRONTEND_BACKEND_PATH to ${SUB_STORE_FRONTEND_BACKEND_PATH}"
    sed -i "s/SUB_STORE_FRONTEND_BACKEND_PATH/${nginx_prefix_path}/g" ${NGINX_CONFIG}
fi

BACKEND_ADDR="${SUB_STORE_BACKEND_API_HOST}:${SUB_STORE_BACKEND_API_PORT}"
if grep -q "BACKEND_ADDR" "${NGINX_CONFIG}"
then
    echo "update BACKEND_ADDR to ${BACKEND_ADDR}"
    sed -i "s#BACKEND_ADDR#${BACKEND_ADDR}#g" ${NGINX_CONFIG}
fi

{
    echo "export SUB_STORE_BACKEND_SYNC_CRON=${SUB_STORE_BACKEND_SYNC_CRON}"
    echo "export SUB_STORE_DATA_BASE_PATH=${SUB_STORE_DATA_BASE_PATH}"
    echo "export SUB_STORE_BACKEND_API_HOST=${SUB_STORE_BACKEND_API_HOST}"
    echo "export SUB_STORE_BACKEND_API_PORT=${SUB_STORE_BACKEND_API_PORT}"
} > /app/.env

. /app/.env
supervisord -c /etc/supervisord.conf