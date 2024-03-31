# LXD (Incus) In Podman

## Description

I am currently running openwrt container using LXD(soon migrating to Incus), which was natively layered from a ucore image.
I was wondering whether I could run LXD inside a podman container, removing the layering aspect entirely from the ucore image.
Given podman has explicit support for SystemD and has Quadlets, thus allowing this project to come fruition.
A very special thanks to ublue, for literally showing how to build podman images and push them to github.

## Table of Contents

- [Limitations](#limitations)
- [Installation](#installation)
- [Credits](#credits)
- [License](#license)
- [Badge](#badge)

## Limitations

- **No VM Support**, I have no use cases for this, but if there is demand, I can try to support it. In fact I have separate project that has libvirt running inside Podman. Perhaps my learnings there can be ported here.
- **!!NO MEMORY LIMITING AND HUGEPAGES SUPPORT!!** Unforunately this is beyond my experience, for now. I'd like to look into the how and why, as I need this functionality.
- I assume CPU pinning wouldn't work either, when the above also doesn't work. Probably related to CGroups V2.

## Installation

Root is mandatory as to mimic the system service of the natively installed LXD.
Though I admit I haven't tested as non-root, so it may or may not work.
Also not tested is not using host network, it also may or may not work.

1. Install latest podman for your distro
2. Either using podman run or Quadlet
   1. Podman Run:
        ```
      sudo podman run -d --network=host --tmpfs /run -v /var/lib/lxd:/var/lib/lxd:z --label io.containers.autoupdate=registry --privileged --systemd=always --tty ghcr.io/vietchinh/lxd-in-podman:latest
      ```
   2. Quadlet:
        ```system
      [Unit]
        Description=LXD In Fedora Container
        
        [Container]
        Image=ghcr.io/vietchinh/lxd-in-podman:latest
        AutoUpdate=registry
        
        Volume=/var/lib/lxd:/var/lib/lxd:z
        
        PodmanArgs=--privileged
        
        Tmpfs=/run
        
        Network=host
        
        [Service]
        Restart=on-failure
        TimeoutStartSec=900
        TimeoutStopSec=240s
        ExecStartPre=+/bin/mkdir -p /var/lib/lxd
        
        [Install]
        WantedBy=multi-user.target default.target
      ```
   3. ```
      sudo podman exec -it systemd-lxd
      ```
   4. ```
      lxc init
      ```
   5. follow the instructions in the command line.


## Credits

- Ublue
- Podman Quadlet
- Podman Run

## License

MIT License, feel free to steal the code and not contribute!

## Badge

[![Create and publish a Podman image](https://github.com/vietchinh/lxd-in-podman/actions/workflows/build.yml/badge.svg)](https://github.com/vietchinh/lxd-in-podman/actions/workflows/build.yml)