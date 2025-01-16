# Sub Store with docker compose

在某个地方听说了 Sub Store，一开始没找着文档，自己手搓了一个 Docker 构建工具，后面发现作者已经提供了 Docker 镜像，奈何做都做了，还是放出来吧，用以纪念我的青春。


## 安装和配置

```shell
# 克隆本项目到 vps
git clone https://github.com/Ansen/Sub-Store-Docker-compose.git Sub-Store
# 切换到项目目录
cd Sub-Store
```

> 修改 docker-compose.yaml 中以下配置即可

- URL: 浏览器访问的域名, 需要带协议头 (http:// 或https://)
- SUB_STORE_FRONTEND_BACKEND_PATH: 后端API 目录前缀，建议随机生成 `echo "/$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 18)"`
- ports: 容器前端页面端口为 3001, 后端端口为 3000，正常情况下只需要将 3001 暴露到容器外。后端端口默认不对外暴露，如有需要请自行取消注释

更多环境变量可以参考[作者](https://hub.docker.com/r/xream/sub-store)的 Docker 镜像，以及[源代码](https://github.com/sub-store-org/Sub-Store/blob/master/backend/src/restful/index.js)

> 常用命令

- 启动: docker-compose up -d
- 更新： docker-compose up -d --build
- 重启：docker-compose restart
- 删除: docker-compose down

> docker、docker-compose ~~安装和使用没啥好说的了，自己找教程吧,~~ 还是说说吧

```shell

# docker

# 国内用这个装
curl -fsSL https://get.docker.com | DOWNLOAD_URL=https://mirrors.ustc.edu.cn/docker-ce bash -s docker

# 国外用这个
curl -fsSL https://get.docker.com | bash -s docker

# docker-compose
# 国内可能无法下载，那玩意你们应该不缺吧？
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

```

## HTTPS 访问(强烈建议)

> 如果是部署在内网环境，可以不管这里

docker 启动后，默认没有配置SSL， 需要自行配置。

建议使用 cloudflare 加速

宿主机 nginx 反代配置文件，供参考

```
server {
  listen 80;
  server_name sub.example.com;


  location / {
        proxy_buffering off;
        proxy_http_version 1.1;

        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        # 注意更新端口
        proxy_pass http://127.0.0.1:39080;
  }

  # 如果要对外暴露后端，取消下面的注释即可建议替换 xxxx 为随机字符串，生成命令参考上面的 SUB_STORE_FRONTEND_BACKEND_PATH
#   location /xxxx/ {
#         proxy_buffering off;
#         proxy_http_version 1.1;

#         proxy_set_header Connection "";
#         proxy_set_header Host $host;
#         proxy_set_header X-Real-IP $remote_addr;
#         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#         # 注意更新端口
#         proxy_pass http://127.0.0.1:39081;
#   }

}
```

# 感谢

- [Sub-Store](https://github.com/sub-store-org/Sub-Store)