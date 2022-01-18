desktop: { pkgs, ... }: {
  imports = [
    ./base.nix
  ] ++ (if desktop then [] else []);
}
