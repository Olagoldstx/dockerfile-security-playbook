FROM node:22-alpine@sha256:0b79a0c6d0e7 as builder
WORKDIR /app
RUN adduser -S -D -H -u 1000 nodeuser
COPY package.json ./
RUN npm ci --only=production

FROM node:22-alpine@sha256:0b79a0c6d0e7
WORKDIR /app
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /app/node_modules /app/node_modules
COPY server.js /app/server.js
USER 1000
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1
CMD ["node","server.js"]
