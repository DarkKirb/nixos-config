#!/bin/sh

#nix flake update
nixos-rebuild build --flake '.#nutty-noon'
nixos-rebuild build --flake '.#nixos-8gb-fsn1-1'
nixos-rebuild build --flake '.#thinkrac'

rm -rf result

nix copy --to 's3://cache.int.chir.rs?scheme=http&endpoint=10.0.2.2:9000' --all
