#!/bin/sh

export NIX_PATH=/etc/nix/inputs
cd packages;
yes '' | ./update.sh