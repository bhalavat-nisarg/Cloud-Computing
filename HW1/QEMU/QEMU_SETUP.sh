#!/bin/bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install qemu qemu-utils qemu-system-x86 -y
sudo qemu-img create ubuntu.img 10G -f qcow2
sudo qemu-system-x86_64 -accel kvm -cpu host -m 2G -smp 2 -boot d -cdrom ~/Downloads/ubuntu-20.04.5-live-server-amd64.iso -hda ubuntu.img -netdev user,id=net0,hostfwd=tcp::5555-:22 -device e1000,netdev=net0 -device ahci,id=ahci -device usb-ehci -device usb-kbd -device usb-mouse -usb
