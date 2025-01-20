#!/bin/sh

set -ex

if [ "$(wc -c $1 | awk '{print $1}')" -le $3 ]; then
    cp $1 $2
    exit 0
fi

for i in $(seq 100 -1 0); do
  cat $1 | pngquant --quality 0-$i - > $2
  [ "$(wc -c $2 | awk '{print $1}')" -le $3 ] && exit 0
done

rm $2
exit 1