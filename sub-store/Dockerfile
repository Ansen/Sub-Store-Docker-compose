FROM node:23-alpine as frontend

ARG URL=https://sub.store

WORKDIR /app

RUN apk add --no-cache git \
    && npm i pnpm -g \
    && git clone https://github.com/sub-store-org/Sub-Store-Front-End.git frontend \
    && cd frontend \
    && sed -i "s#https://sub.store#${URL}#g" .env.production \
    && pnpm i \
    && pnpm build

    
FROM node:23-alpine

WORKDIR /app

COPY --chown=root:root files /app/files
COPY --from=frontend  --chown=root:root /app/frontend/dist /app/html

RUN apk add --no-cache supervisor \
    && cp -rf files/supervisord.conf /etc/supervisord.conf \
    && cp -rf files/entrypoint.sh /entrypoint.sh \
    && chmod +x /entrypoint.sh \
    && wget -q  https://github.com/sub-store-org/Sub-Store/releases/latest/download/sub-store.bundle.js -O sub-store.bundle.js \
    && mkdir /db \
    && rm -rf files

ENTRYPOINT ["/bin/sh","/entrypoint.sh" ]