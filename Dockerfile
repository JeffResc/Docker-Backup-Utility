FROM alpine:3.12.0
MAINTAINER jeff@jeffresc.dev

RUN apk update --no-cache && apk add --no-cache docker-cli rclone jq zip coreutils

COPY ./script.sh /root/script.sh
RUN chmod +x /root/script.sh

CMD ["/root/script.sh"]