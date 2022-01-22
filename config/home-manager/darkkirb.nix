desktop: { pkgs, ... }: {
  imports = [
    ./base.nix
    ../programs/gpg.nix
    ../programs/git.nix
  ] ++ (if desktop then [
    ../programs/sway.nix
    ../programs/firefox.nix
    ../programs/theming.nix
    ../programs/waybar.nix
    ../programs/ims.nix
    ../programs/syncthing.nix
    ../programs/mpd.nix
    ../games/default.nix
  ] else [ ]);
}
