{nixpkgs, ...}: {
  imports = [
    (nixpkgs.outPath + "/nixos/modules/profiles/minimal.nix")
    (nixpkgs.outPath + "/nixos/modules/profiles/headless.nix")
  ];
}
