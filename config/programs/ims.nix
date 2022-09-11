{
  config,
  pkgs,
  nixpkgs-fluffychat,
  ...
}: let
in {
  home.packages = with pkgs; [
    nixpkgs-fluffychat.legacyPackages.${system}.fluffychat
  ];
}
