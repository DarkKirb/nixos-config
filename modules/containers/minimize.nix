{ nixpkgs, ... }:
{
  imports = [
    (nixpkgs.outPath + "/nixos/modules/profiles/minimal.nix")
    (nixpkgs.outPath + "/nixos/modules/profiles/headless.nix")
  ];
  nix.enable = false; # We don’t need the nix package manager inside of the container.
}
