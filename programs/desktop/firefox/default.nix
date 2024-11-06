{
  pkgs,
  config,
  lib,
  ...
}: let
  extensions = {
    "ublock-origin" = [
      "alarms"
      "dns"
      "menus"
      "privacy"
      "storage"
      "tabs"
      "unlimitedStorage"
      "webNavigation"
      "webRequest"
      "webRequestBlocking"
      "<all_urls>"
      "http://*/*"
      "https://*/*"
      "file://*/*"
      "https://easylist.to/*"
      "https://*.fanboy.co.nz/*"
      "https://filterlists.com/*"
      "https://forums.lanik.us/*"
      "https://github.com/*"
      "https://*.github.io/*"
      "https://github.com/uBlockOrigin/*"
      "https://ublockorigin.github.io/*"
      "https://*.reddit.com/r/uBlockOrigin/*"
    ];
    "sidebery" = [
      "activeTab"
      "tabs"
      "contextualIdentities"
      "cookies"
      "storage"
      "unlimitedStorage"
      "sessions"
      "menus"
      "menus.overrideContext"
      "search"
      "theme"
    ];
    "darkreader" = [
      "alarms"
      "contextMenus"
      "storage"
      "tabs"
      "theme"
      "<all_urls>"
    ];
    "plasma-integration" = [
      "nativeMessaging"
      "notifications"
      "storage"
      "downloads"
      "tabs"
      "<all_urls>"
      "contextMenus"
      "*://*/*"
    ];
    "keepassxc-browser" = [
      "activeTab"
      "clipboardWrite"
      "contextMenus"
      "cookies"
      "nativeMessaging"
      "notifications"
      "storage"
      "tabs"
      "webNavigation"
      "webRequest"
      "webRequestBlocking"
      "https://*/*"
      "http://*/*"
      "https://api.github.com/"
      "<all_urls>"
    ];
    "sponsorblock" = [
      "storage"
      "scripting"
      "https://sponsor.ajay.app/*"
      "https://*.youtube.com/*"
      "https://www.youtube-nocookie.com/embed/*"
    ];
    "dearrow" = [
      "storage"
      "unlimitedStorage"
      "alarms"
      "https://sponsor.ajay.app/*"
      "https://dearrow-thumb.ajay.app/*"
      "https://*.googlevideo.com/*"
      "https://*.youtube.com/*"
      "https://www.youtube-nocookie.com/embed/*"
      "scripting"
    ];
  };
in {
  programs.firefox = {
    enable = true;
    profiles.default = {
      containersForce = true;
      extensions = map (v: config.nur.repos.rycee.firefox-addons.${v}) (lib.attrNames extensions);
      settings = {
        "extensions.autoDisableScopes" = 0;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = ''
        @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");
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
  assertions =
    lib.mapAttrsToList (k: v: let
      unaccepted =
        lib.subtractLists
        v
        config.nur.repos.rycee.firefox-addons.${k}.meta.mozPermissions;
    in {
      assertion = unaccepted == [];
      message = ''
        Extension ${k} has unaccepted permissions: ${builtins.toJSON unaccepted}'';
    })
    extensions;
  value.home.persistence.default.directories = [
    ".mozilla"
  ];
}
