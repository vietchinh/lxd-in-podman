ARG FEDORA_VERSION
ARG PACKAGE_NAME
ARG PACKAGE_VERSION
ENV PACKAGE=${PACKAGE_NAME}-${PACKAGE_VERSION}.fc${FEDORA_VERSION}

FROM registry.fedoraproject.org/fedora:${FEDORA_VERSION}
MAINTAINER vietchinh

VOLUME ["/var/lib/lxd"]

RUN echo ${PACKAGE}
RUN echo ${PACKAGE_NAME}
RUN echo ${PACKAGE_VERSION}
RUN echo ${PACKAGE_NAME}-${PACKAGE_VERSION}.fc${FEDORA_VERSION}

RUN dnf install https://zfsonlinux.org/fedora/zfs-release-2-4$(rpm --eval "%{dist}").noarch.rpm dnf-plugins-core --setopt=install_weak_deps=False --nodocs -y && \
    dnf copr enable ganto/lxc4 -y && \
    dnf install systemd iproute nano zfs ${PACKAGE} dnf-automatic --setopt=install_weak_deps=False --nodocs -y && \
    dnf clean all

RUN echo "root:1000000:65536" >> /etc/subuid; \
    echo "root:1000000:65536" >> /etc/subgid; \
    source /etc/profile

RUN (cd /usr/lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /usr/lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /usr/lib/systemd/system/local-fs.target.wants/*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /usr/lib/systemd/system/basic.target.wants/*; \
    rm -f /usr/lib/systemd/system/anaconda.target.wants/*; \
    systemctl enable ${PACKAGE_NAME}; systemctl enable dnf-automatic-install.timer

CMD ["/sbin/init"]