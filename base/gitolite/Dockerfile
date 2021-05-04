FROM alpine

RUN apk add --no-cache \
        gitolite openssh cgit spawn-fcgi fcgiwrap nginx && \
    passwd -u git

COPY nginx.conf /etc/nginx/conf.d/nginx.conf
COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
