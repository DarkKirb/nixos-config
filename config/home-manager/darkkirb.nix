{ desktop, args }: { pkgs, ... }: {
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
    (import ../games/default.nix args)
    ../programs/yubikey.nix
    ../programs/keybase.nix
    ../programs/keepass.nix
    ../programs/alacritty.nix
    ../programs/kicad.nix
  ] else [ ]);
}
