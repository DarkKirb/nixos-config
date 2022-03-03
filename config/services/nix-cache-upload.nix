{ pkgs, ... }:
let
in
{
  systemd.services.copy-to-cache = {
    enable = true;
    description = "Copy nix cache to cache.int.chir.rs";
    script = ''
      #!${pkgs.bash}/bin/bash
      ${pkgs.nix}/bin/nix store sign --key-file /root/cache-priv-key.pem --all
      ${pkgs.nix}/bin/nix copy --to 's3://nix-cache?scheme=https&endpoint=cache.int.chir.rs&multipart-upload=true' --all
      ${pkgs.minio-client}/bin/mc rm -r --older-than 7d nix-cache/nix-cache 
    '';
  };
  systemd.timers.copy-to-cache = {
    enable = true;
    description = "Copy nix cache to cache.int.chir.rs";
    requires = [ "copy-to-cache.service" ];
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnUnitActiveSec = 300;
      OnBootSec = 300;
    };
  };
}
