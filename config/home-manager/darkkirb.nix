desktop: { pkgs, ... }: {
  imports = [
    (import ./base.nix desktop)
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
    ../programs/zoom.nix
    ../programs/plover.nix
    ../programs/texlive.nix
    ../games/default.nix
    ../programs/yubikey.nix
    ../programs/keybase.nix
  ] else [ ]);
}
