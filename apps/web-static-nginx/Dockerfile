FROM nginx:1.27-alpine AS base
# create unprivileged user and deps
RUN adduser -S -D -H -u 1000 webuser && apk add --no-cache wget
# create writable temp/cache dirs for non-root
RUN mkdir -p /tmp/nginx/client_temp /tmp/nginx/proxy_temp /tmp/nginx/fastcgi_temp /tmp/nginx/uwsgi_temp /tmp/nginx/scgi_temp \
    && chown -R 1000:1000 /tmp/nginx
# copy config and content
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html
USER 1000
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1
