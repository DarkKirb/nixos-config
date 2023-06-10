{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [./kubo-common.nix];
  services.kubo = {
    package = pkgs.kubo-orig;
  };
  fileSystems."/var/lib/ipfs/root" = {
    device = "/";
    options = ["bind" "ro"];
  };
}
