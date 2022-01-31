#!/bin/sh

set -eu

apt update && apt upgrade -y
apt install -y curl git openjdk-16-jre maven
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
apt install -y nodejs
