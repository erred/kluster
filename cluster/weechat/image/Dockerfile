FROM weechat/weechat:latest-alpine-slim

USER root
RUN apk add screen
USER user
WORKDIR /home/user
COPY screenrc .screenrc
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT entrypoint.sh
