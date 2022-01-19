{ ... }: {
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
    ];
  };
  programs.msmtp.enable = true;
}
