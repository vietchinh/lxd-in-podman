FROM alpine:latest
MAINTAINER vietchinh

RUN apk add --update --no-cache openrc lxd

VOLUME ["/var/lib/lxd"]

CMD ["/sbin/init"]