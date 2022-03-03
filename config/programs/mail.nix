{ pkgs, ... }:
let
  mailcap = pkgs.writeText "mailcap" ''
    text/html; ${pkgs.w3m}/bin/w3m -I %{charset} -T text/html; copiousoutput;
    image/*; ${pkgs.imv}/bin/imv %s
  '';
in
{
  services.imapnotify.enable = true;
  programs.mbsync.enable = true;
  programs.notmuch = {
    enable = true;
  };
  programs.neomutt = {
    enable = true;
    vimKeys = true;
    sidebar = {
      enable = true;
    };
    binds = [
      {
        key = "\\CA";
        action = "sidebar-next";
        map = [ "index" "pager" ];
      }
      {
        key = "\\CL";
        action = "sidebar-prev";
        map = [ "index" "pager" ];
      }
      {
        key = "\\CP";
        action = "sidebar-open";
        map = [ "index" "pager" ];
      }
      {
        key = "<Return>"; # what the fuck is this mapping
        action = "display-message";
        map = [ "index" ];
      }
      {
        key = "\\CV";
        action = "display-message"; # i give up
        map = [ "index" ];
      }
    ];
    extraConfig = ''
      virtual-mailboxes "To Do" "notmuch://?query=tag:todo"
      virtual-mailboxes "To Read" "notmuch://?query=tag:toread"
      virtual-mailboxes "Blocked" "notmuch://?query=tag:blocked"
      virtual-mailboxes "Archive" "notmuch://?query=tag:archive"
      macro index,pager A "<modify-labels-then-hide>+archive -unread -inbox\n"
      bind index,pager y modify-labels
      set mailcap_path = ${mailcap}
    '';
  };
  programs.msmtp.enable = true;
}
