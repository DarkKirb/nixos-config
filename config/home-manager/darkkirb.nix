{
  desktop,
  args,
}: {pkgs, ...}: {
  imports =
    [
      (import ./base.nix desktop)
      ../programs/gpg.nix
      ../programs/git.nix
      ../programs/direnv.nix
    ]
    ++ (
      if desktop
      then [
        ../programs/sway.nix
        ../programs/firefox.nix
        ../programs/theming.nix
        ../programs/waybar.nix
        ../programs/ims.nix
        ../programs/syncthing.nix
        ../programs/mpd.nix
        ../programs/zoom.nix
        ../programs/plover.nix
        (import ../games/default.nix args)
        ../programs/yubikey.nix
        ../programs/keybase.nix
        ../programs/keepass.nix
        ../programs/kicad.nix
        ../programs/misc.nix
        ../programs/mail.nix
        ../programs/kitty.nix
        ../programs/fcitx.nix
      ]
      else []
    );
}
