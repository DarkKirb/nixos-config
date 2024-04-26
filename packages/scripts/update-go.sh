#!/usr/bin/env bash
SOURCE=$1
WRITE_PATH=$(realpath $2)

nix run github:darkkirb/gomod2nix -vL -- --dir $SOURCE --outdir $WRITE_PATH
