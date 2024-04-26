#!/usr/bin/env nix-shell
#!nix-shell -i bash -p go gnumake

set -x

export GO111MODULE=on

SOURCE=$1
WRITE_PATH=$(realpath $2)
SOURCE_EXTRACTED=$(mktemp -du)

cp -r $SOURCE $SOURCE_EXTRACTED
chmod -R +w $SOURCE_EXTRACTED

cd $SOURCE_EXTRACTED

for module in $3; do
    go get $module
done

echo -e "\nstorjds storj.io/ipfs-go-ds-storj/plugin 0" >> plugin/loader/preload_list

go mod tidy

make build

for module in $3; do
    go get $module
done

make build

cp go.mod go.sum $WRITE_PATH

nix run github:nix-community/gomod2nix -- --dir $SOURCE_EXTRACTED --outdir $WRITE_PATH
