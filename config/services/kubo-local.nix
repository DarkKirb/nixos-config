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
}
