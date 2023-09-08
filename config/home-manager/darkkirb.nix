{
  desktop,
  args,
}: {pkgs, ...}: {
  imports =
    [
      (import ./base.nix desktop)
      ../programs/ssh.nix
      (import ../programs/git.nix desktop)
      ../programs/direnv.nix
    ]
    ++ (
      if desktop
      then [
        ../programs/firefox.nix
        ../programs/ims.nix
        ../programs/syncthing.nix
        ../programs/plover.nix
        (import ../games/default.nix args)
        ../programs/yubikey.nix
        ../programs/keybase.nix
        ../programs/keepass.nix
        ../programs/vscode
        ../programs/misc.nix
        ../programs/zk.nix
        ../programs/fcitx.nix
        ../programs/gpg.nix
      ]
      else []
    );
}
