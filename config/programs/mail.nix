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
        key = "g";
        action = "noop";
        map = [ "attach" "browser" "index" "pager" ];
      }
      {
        key = "gg";
        action = "first-entry";
        map = [ "attach" "browser" "index" ];
      }
      {
        key = "G";
        action = "last-entry";
        map = [ "attach" "browser" "index" ];
      }
      {
        key = "gg";
        action = "top";
        map = [ "pager" ];
      }
      {
        key = "G";
        action = "bottom";
        map = [ "pager" ];
      }
      {
        key = "k";
        action = "previous-line";
        map = [ "pager" ];
      }
      {
        key = "j";
        action = "next-line";
        map = [ "pager" ];
      }
      {
        key = "\\CF";
        action = "next-page";
        map = [ "attach" "browser" "pager" "index" ];
      }
      {
        key = "\\CB";
        action = "previous-page";
        map = [ "attach" "browser" "pager" "index" ];
      }
      {
        key = "\\Cu";
        action = "half-up";
        map = [ "attach" "browser" "pager" "index" ];
      }
      {
        key = "\\Cd";
        action = "half-down";
        map = [ "attach" "browser" "pager" "index" ];
      }
      {
        key = "\\Ce";
        action = "next-line";
        map = [ "browser" "pager" "index" ];
      }
      {
        key = "\\Cy";
        action = "previous-line";
        map = [ "browser" "pager" "index" ];
      }
      {
        key = "d";
        action = "noop";
        map = [ "pager" "index" ];
      }
      {
        key = "dd";
        action = "delete-message";
        map = [ "pager" "index" ];
      }
      {
        key = "\\Cm";
        action = "list-reply";
        map = [ "index" ];
      }
      {
        key = "N";
        action = "search-opposite";
        map = [ "browser" "pager" "index" ];
      }
      {
        key = "dT";
        action = "delete-thread";
        map = [ "pager" "index" ];
      }
      {
        key = "dt";
        action = "delete-subthread";
        map = [ "pager" "index" ];
      }
      {
        key = "gt";
        action = "next-thread";
        map = [ "pager" "index" ];
      }
      {
        key = "gT";
        action = "previous-thread";
        map = [ "pager" "index" ];
      }
      {
        key = "za";
        action = "collapse-thread";
        map = [ "index" ];
      }
      {
        key = "zA";
        action = "collapse-all";
        map = [ "index" ];
      }
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
