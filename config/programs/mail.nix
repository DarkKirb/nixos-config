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
      }
      {
        key = "\\CL";
        action = "sidebar-prev";
      }
      {
        key = "\\CP";
        action = "sidebar-open";
      }
    ];
  };
  programs.msmtp.enable = true;
}
