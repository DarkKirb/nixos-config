{
  pkgs,
  config,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      containersForce = true;
      extensions = []; # TODO
      path = "${config.xdg.dataHome}/mozilla/default";
      settings = {
        "extensions.autoDisableScopes" = 0;
      };
      userChrome = ''
        #main-window #titlebar {
          overflow: hidden;
          transition: height 0.3s 0.3s !important;
        }
        /* Default state: Set initial height to enable animation */
        #main-window #titlebar { height: 3em !important; }
        #main-window[uidensity="touch"] #titlebar { height: 3.35em !important; }
        #main-window[uidensity="compact"] #titlebar { height: 2.7em !important; }
        /* Hidden state: Hide native tabs strip */
        #main-window[titlepreface*="​"] #titlebar { height: 0 !important; }
        /* Hidden state: Fix z-index of active pinned tabs */
        #main-window[titlepreface*="​"] #tabbrowser-tabs { z-index: 0 !important; }
      '';
    };
  };
}
