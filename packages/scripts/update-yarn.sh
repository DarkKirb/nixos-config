#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yarn2nix nodejs yarn

SOURCE=$1
WRITE_PATH=$(realpath $2)
SOURCE_EXTRACTED=$(mktemp -du)

cp -r $SOURCE $SOURCE_EXTRACTED
chmod -R +w $SOURCE_EXTRACTED

cd $SOURCE_EXTRACTED

yarn install

yarn2nix --lockfile $SOURCE_EXTRACTED/yarn.lock > $WRITE_PATH/yarn.nix
cp $SOURCE_EXTRACTED/package.json $WRITE_PATH/package.json
cp $SOURCE_EXTRACTED/yarn.lock $WRITE_PATH/yarn.lock


rm -rf $SOURCE_EXTRACTED
