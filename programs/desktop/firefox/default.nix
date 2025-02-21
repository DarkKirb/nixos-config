{
  pkgs,
  lib,
  rycee-nur-expressions,
  ...
}:
let
  rycee = import rycee-nur-expressions { inherit pkgs; };
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
      "identity"
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
in
{
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = with pkgs; [
      kdePackages.plasma-browser-integration
      keepassxc
    ];
    profiles.default = {
      containersForce = true;
      extensions.packages = map (v: rycee.firefox-addons.${v}) (lib.attrNames extensions);
      settings = {
        "extensions.autoDisableScopes" = 0;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.inTitlebar" = 0;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.location" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;
        "widget.use-xdg-desktop-portal.open-uri" = 1;
        "widget.use-xdg-desktop-portal.settings" = 1;
        "extensions.pocket.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.default.sites" = "";
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
  assertions = lib.mapAttrsToList (
    k: v:
    let
      unaccepted = lib.subtractLists v rycee.firefox-addons.${k}.meta.mozPermissions;
    in
    {
      assertion = unaccepted == [ ];
      message = ''Extension ${k} has unaccepted permissions: ${builtins.toJSON unaccepted}'';
    }
  ) extensions;
}
