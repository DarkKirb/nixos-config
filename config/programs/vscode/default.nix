{
  pkgs,
  nixpkgs,
  lib,
  nixos-vscode-server,
  ...
}: let
  x86_64-linux-pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in {
  imports = [
    "${nixos-vscode-server}/modules/vscode-server/home.nix"
  ];
  programs.vscode = {
    enable = true;
    extensions = with x86_64-linux-pkgs.vscode-extensions; [
    ];
  };
  services.vscode-server.enable = true;
}
