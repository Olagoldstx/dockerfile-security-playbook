# Multi-stage: builder
FROM --platform=$BUILDPLATFORM python:3.12-alpine AS builder
WORKDIR /opt/app
RUN adduser -S -D -H -u 1000 appuser
COPY requirements.txt .
RUN apk add --no-cache gcc musl-dev libffi-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    rm -rf /root/.cache

# Final stage
FROM python:3.12-alpine
LABEL org.opencontainers.image.source="https://example.com/repo"
WORKDIR /opt/app
COPY --from=builder /usr/local /usr/local
COPY --from=builder /etc/passwd /etc/passwd
COPY app.py entrypoint.sh ./
# install healthcheck dependency while still root
RUN apk add --no-cache wget
USER 1000
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1
ENTRYPOINT ["./entrypoint.sh"]
