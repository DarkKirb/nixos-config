desktop: { pkgs, ... }: {
  imports = [
    ./base.nix
    ../programs/gpg.nix
    ../programs/git.nix
  ] ++ (if desktop then [ ../programs/sway.nix ../programs/firefox.nix ] else []);
}
