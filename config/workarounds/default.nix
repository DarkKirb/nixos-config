{
  self,
  system,
  ...
}: {
  nixpkgs.overlays = [
    self.overlays.${system}
  ];
}
