{ pkgs, ... }:
let
in
{
  systemd.services.copy-to-cache = {
    enable = true;
    description = "Copy nix cache to cache.int.chir.rs";
    script = ''
      #!${pkgs.bash}/bin/bash
      ${pkgs.nix}/bin/nix copy --to 's3://cache.int.chir.rs?scheme=http&endpoint=192.168.2.1:9000' --all
    '';
    unitConfig = {
      User = "darkkirb";
      Group = "users";
    };
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
