desktop: { pkgs, ... }: {
  imports = [
    ./base.nix
  ] ++ if desktop then [
    ../programs/sway.nix
  ] else [];
}
