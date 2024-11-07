{
  pkgs,
  config,
  lib,
  nur,
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
  nur' = import nur {
    nurpkgs = pkgs;
    inherit pkgs;
  };
in {
  programs.firefox = {
    enable = true;
    profiles.default = {
      containersForce = true;
      extensions = map (v: nur'.repos.rycee.firefox-addons.${v}) (lib.attrNames extensions);
      settings = {
        "extensions.autoDisableScopes" = 0;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.inTitlebar" = 0;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.location" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;
        "widget.use-xdg-desktop-portal.open-uri" = 1;
        "widget.use-xdg-desktop-portal.settings" = 1;
      };
      userChrome = ''
        @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");

        #TabsToolbar {
          visibility: collapse;
        }

        #titlebar {
          display: none;
        }

        #sidebar-header {
          display: none;
        }
      '';
    };
  };
  assertions =
    lib.mapAttrsToList (k: v: let
      unaccepted =
        lib.subtractLists
        v
        nur'.repos.rycee.firefox-addons.${k}.meta.mozPermissions;
    in {
      assertion = unaccepted == [];
      message = ''
        Extension ${k} has unaccepted permissions: ${builtins.toJSON unaccepted}'';
    })
    extensions;
  home.persistence.default.directories = [
    ".mozilla"
  ];
}
