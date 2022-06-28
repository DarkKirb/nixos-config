{pkgs, ...}: let
in {
  services.imapnotify.enable = true;
  programs.mbsync.enable = true;
  programs.alot = {
    enable = true;
  };
  programs.msmtp.enable = true;
}
