{
  self,
  nix-packages,
  system,
  ...
}: {
  nixpkgs.overlays = [
    self.overlays.${system}
    nix-packages.overlays.${system}.default
  ];
}
