{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.keepassxc];
}
