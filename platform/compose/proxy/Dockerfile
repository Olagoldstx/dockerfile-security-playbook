FROM alpine:3.20
RUN apk add --no-cache tinyproxy
RUN sed -i 's/^#Port .*/Port 3128/' /etc/tinyproxy/tinyproxy.conf && \
    sed -i 's/^#Listen .*/Listen 0.0.0.0/' /etc/tinyproxy/tinyproxy.conf && \
    sed -i 's/^Allow .*/# Allow 127.0.0.1/' /etc/tinyproxy/tinyproxy.conf && \
    printf "Allow 10.0.0.0/8\nAllow 172.16.0.0/12\nAllow 192.168.0.0/16\n" >> /etc/tinyproxy/tinyproxy.conf && \
    sed -i 's/^#DisableViaHeader.*/DisableViaHeader Yes/' /etc/tinyproxy/tinyproxy.conf && \
    sed -i 's/^#ConnectPort .*/ConnectPort 443/' /etc/tinyproxy/tinyproxy.conf && \
    sed -i 's/^#ConnectPort .*/ConnectPort 80/' /etc/tinyproxy/tinyproxy.conf
EXPOSE 3128
ENTRYPOINT ["tinyproxy","-d"]
