FROM registry.fedoraproject.org/fedora-minimal:latest
MAINTAINER vietchinh

RUN microdnf install -y https://zfsonlinux.org/fedora/zfs-release-2-4$(rpm --eval "%{dist}").noarch.rpm && \
    microdnf install dnf5-command(copr) systemd iproute nano zfs --setopt=install_weak_deps=False --nodocs -y && \
    microdnf copr enable ganto/lxc4 -y && \
    microdnf install lxd --setopt=install_weak_deps=False --nodocs -y && \
    microdnf clean all

RUN (cd /usr/lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /usr/lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /usr/lib/systemd/system/local-fs.target.wants/*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /usr/lib/systemd/system/basic.target.wants/*; \
    rm -f /usr/lib/systemd/system/anaconda.target.wants/*; \
    systemctl enable lxd

VOLUME ["/var/lib/lxd"]

CMD ["/sbin/init"]