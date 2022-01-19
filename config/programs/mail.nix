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
        key = "^A";
        action = "sidebar-next";
      }
      {
        key = "^L";
        action = "sidebar-prev";
      }
      {
        key = "^P";
        action = "sidebar-open";
      }
    ];
  };
  programs.msmtp.enable = true;
}
