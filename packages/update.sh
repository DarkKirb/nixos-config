#!/bin/sh

#./scripts/update-git.sh https://github.com/starfive-tech/linux linux/vf2/source.json "--rev refs/heads/JH7110_VisionFive2_upstream"
#./scripts/update-git.sh https://github.com/koverstreet/bcachefs linux/bcachefs/source.json
nix-shell ./scripts/update.nix
