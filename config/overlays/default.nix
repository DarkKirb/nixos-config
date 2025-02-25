{
  inTester,
  system,
  self,
  rust-overlay,
  nix-vscode-extensions,
  nix-gaming,
  jujutsu,
  ...
}:
{
  imports =
    if !inTester then
      (
        [
          ./inputs-overlay.nix
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
