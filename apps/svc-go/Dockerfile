FROM golang:1.22-alpine@sha256:1b2e1177a as builder
WORKDIR /src
RUN adduser -S -D -H -u 1000 gopher
COPY main.go .
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o app main.go

FROM gcr.io/distroless/static@sha256:8b5d9e16a8ce59f12f2f6
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /src/app /app
USER 1000
EXPOSE 8080
HEALTHCHECK NONE
ENTRYPOINT ["/app"]
