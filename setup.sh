#!/usr/bin/env bash


# Check if user is root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

echo '[+] Running: apt-get update -y'
apt-get update -y

echo '[+] Downloading Dependencies'
apt install libimage-exiftool-perl -y

echo '[+] Downloading Dependencies'
apt-get install steghide -y
pip3 install stegcracker

echo '[+] Congratulations, All tools installed successfully!'
