#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq nix

set -ex

builds=$(curl -H 'accept: application/json' https://hydra.int.chir.rs/jobset/nixos-config/nixos-config/evals | jq -r '.evals[0].builds[]')

for build in $builds; do
    doc=$(curl -H 'accept: application/json' https://hydra.int.chir.rs/build/$build)
    system=$(echo $doc | jq -r '.system')
    jobname=$(echo $doc | jq -r '.job')
    if [ "$jobname" = "$(hostname).$system" ]; then
        drvname=$(echo $doc | jq -r '.drvpath')
        output=$(nix-store -r $drvname)
        $output/bin/switch-to-configuration switch
        exit
    fi
done
