{
  inTester,
  system,
  self,
  rust-overlay,
  nix-vscode-extensions,
  nix-gaming,
  jujutsu,
  gomod2nix,
  ...
}:
{
  imports =
    if !inTester then
      (
        [
          ./inputs-overlay.nix
          ./staging-workarounds.nix
        ]
        ++ (
          if system == "riscv64-linux" then
            [
              ./riscv.nix
              ./riscv-cross-packages.nix
            ]
          else
            [ ]
        )
      )
    else
      [ ];
}
// (
  if !inTester then
    {
      nixpkgs.overlays = [
        gomod2nix.overlays.default
        self.overlays.default
        (import rust-overlay)
        nix-vscode-extensions.overlays.default
        nix-gaming.overlays.default
        jujutsu.overlays.default
      ];
    }
  else
    { }
)
