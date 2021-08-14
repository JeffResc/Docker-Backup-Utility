FROM alpine:3.14.1
LABEL maintainer="jeff@jeffresc.dev"

RUN apk update --no-cache && apk add --no-cache docker-cli rclone jq coreutils

COPY ./script.sh /root/script.sh
RUN chmod +x /root/script.sh

CMD ["/root/script.sh"]