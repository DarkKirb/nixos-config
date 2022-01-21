{ pkgs, ... }:
let
in
{
  systemd.services.copy-to-cache = {
    enable = true;
    description = "Copy nix cache to cache.int.chir.rs";
    script = ''
      #!${pkgs.bash}/bin/bash
      ${pkgs.nix}/bin/nix copy --to 's3://cache.int.chir.rs?scheme=https&endpoint=minio.int.chir.rs' --all
    '';
    unitConfig = {
      user = "darkkirb";
      group = "users";
    };
  };
  systemd.timers.copy-to-cache = {
    enable = true;
    description = "Copy nix cache to cache.int.chir.rs";
    requires = [ "copy-to-cache.service" ];
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnUnitActiveSec = 3600;
      OnBootSec = 3600;
    };
  };
}
