FROM alpine:latest
MAINTAINER vietchinh

RUN apk add --update --no-cache openrc lxc lxc-templates

VOLUME ["/var/lib/lxd"]

CMD ["/sbin/init"]