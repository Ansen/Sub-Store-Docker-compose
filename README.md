## Sub Store with docker compose

修改 docker-compose.yaml 中的 URL 和 SUB_STORE_FRONTEND_BACKEND_PATH 的值，然后 docker-compose up -d 运行

默认是 http 访问，建议使用 cloudflare 加速

宿主机 nginx 反代配置文件 参考

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
        proxy_pass http://127.0.0.1:39080;
  }

}
```

# 感谢

- [Sub-Store](https://github.com/sub-store-org/Sub-Store)