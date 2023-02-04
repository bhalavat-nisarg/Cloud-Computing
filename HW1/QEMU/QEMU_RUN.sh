#!/bin/bash
sudo qemu-system-x86_64 -accel kvm -cpu host -m 2G -smp 2 -boot c -cdrom ./Downloads/ubuntu-20.04.5-live-server-amd64.iso -hda ubuntu.img -netdev user,id=net0,hostfwd=tcp::5555-:22 -device e1000,netdev=net0 -device ahci,id=ahci -device usb-ehci -device usb-kbd -device usb-mouse –usb
