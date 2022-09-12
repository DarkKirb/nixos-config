{
  config,
  pkgs,
  nixpkgs-fluffychat,
  ...
}: let
  pkgs-fluffychat = import nixpkgs-fluffychat { inherit (pkgs) system; };
in {
  home.packages = with pkgs; [
    (pkgs-fluffychat.callPackage ./fluffychat.nix {})
  ];
}
