ARG FEDORA_VERSION

FROM ghcr.io/vietchinh/fedora-init:${FEDORA_VERSION}
MAINTAINER vietchinh

VOLUME ["/var/lib/lxd"]

ARG FEDORA_VERSION
ARG PACKAGE_NAME
ARG PACKAGE_VERSION

RUN dnf install https://zfsonlinux.org/fedora/zfs-release-2-4$(rpm --eval "%{dist}").noarch.rpm dnf-plugins-core --setopt=install_weak_deps=False --nodocs -y && \
    dnf copr enable ganto/lxc4 -y && \
    dnf install iproute nano zfs lvm2 btrfs-progs ${PACKAGE_NAME}-${PACKAGE_VERSION}.fc${FEDORA_VERSION} --setopt=install_weak_deps=False --nodocs -y && \
    dnf clean all && \
    systemctl enable ${PACKAGE_NAME}

RUN echo "root:1000000:65536" >> /etc/subuid; \
    echo "root:1000000:65536" >> /etc/subgid; \
    source /etc/profile

CMD ["/sbin/init"]