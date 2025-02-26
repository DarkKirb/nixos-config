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
    "indie-wiki-buddy" = [
      "storage"
      "webRequest"
      "notifications"
      "scripting"
      "https://*.fandom.com/*"
      "https://*.fextralife.com/*"
      "https://*.neoseeker.com/*"
      "https://breezewiki.com/*"
      "https://antifandom.com/*"
      "https://bw.artemislena.eu/*"
      "https://breezewiki.catsarch.com/*"
      "https://breezewiki.esmailelbob.xyz/*"
      "https://breezewiki.frontendfriendly.xyz/*"
      "https://bw.hamstro.dev/*"
      "https://breeze.hostux.net/*"
      "https://breezewiki.hyperreal.coffee/*"
      "https://breeze.mint.lgbt/*"
      "https://breezewiki.nadeko.net/*"
      "https://nerd.whatever.social/*"
      "https://breeze.nohost.network/*"
      "https://z.opnxng.com/*"
      "https://bw.projectsegfau.lt/*"
      "https://breezewiki.pussthecat.org/*"
      "https://bw.vern.cc/*"
      "https://breeze.whateveritworks.org/*"
      "https://breezewiki.woodland.cafe/*"
      "https://*.bing.com/search*"
      "https://search.brave.com/search*"
      "https://*.duckduckgo.com/*"
      "https://*.ecosia.org/*"
      "https://kagi.com/search*"
      "https://*.qwant.com/*"
      "https://*.search.yahoo.com/*"
      "https://*.startpage.com/*"
      "https://*.ya.ru/*"
      "https://*.yandex.az/*"
      "https://*.yandex.by/*"
      "https://*.yandex.co.il/*"
      "https://*.yandex.com.am/*"
      "https://*.yandex.com.ge/*"
      "https://*.yandex.com.tr/*"
      "https://*.yandex.com/*"
      "https://*.yandex.ee/*"
      "https://*.yandex.eu/*"
      "https://*.yandex.fr/*"
      "https://*.yandex.kz/*"
      "https://*.yandex.lt/*"
      "https://*.yandex.lv/*"
      "https://*.yandex.md/*"
      "https://*.yandex.ru/*"
      "https://*.yandex.tj/*"
      "https://*.yandex.tm/*"
      "https://*.yandex.uz/*"
      "https://www.google.com/search*"
      "https://www.google.ad/search*"
      "https://www.google.ae/search*"
      "https://www.google.com.af/search*"
      "https://www.google.com.ag/search*"
      "https://www.google.com.ai/search*"
      "https://www.google.al/search*"
      "https://www.google.am/search*"
      "https://www.google.co.ao/search*"
      "https://www.google.com.ar/search*"
      "https://www.google.as/search*"
      "https://www.google.at/search*"
      "https://www.google.com.au/search*"
      "https://www.google.az/search*"
      "https://www.google.ba/search*"
      "https://www.google.com.bd/search*"
      "https://www.google.be/search*"
      "https://www.google.bf/search*"
      "https://www.google.bg/search*"
      "https://www.google.com.bh/search*"
      "https://www.google.bi/search*"
      "https://www.google.bj/search*"
      "https://www.google.com.bn/search*"
      "https://www.google.com.bo/search*"
      "https://www.google.com.br/search*"
      "https://www.google.bs/search*"
      "https://www.google.bt/search*"
      "https://www.google.co.bw/search*"
      "https://www.google.by/search*"
      "https://www.google.com.bz/search*"
      "https://www.google.ca/search*"
      "https://www.google.cd/search*"
      "https://www.google.cf/search*"
      "https://www.google.cg/search*"
      "https://www.google.ch/search*"
      "https://www.google.ci/search*"
      "https://www.google.co.ck/search*"
      "https://www.google.cl/search*"
      "https://www.google.cm/search*"
      "https://www.google.cn/search*"
      "https://www.google.com.co/search*"
      "https://www.google.co.cr/search*"
      "https://www.google.com.cu/search*"
      "https://www.google.cv/search*"
      "https://www.google.com.cy/search*"
      "https://www.google.cz/search*"
      "https://www.google.de/search*"
      "https://www.google.dj/search*"
      "https://www.google.dk/search*"
      "https://www.google.dm/search*"
      "https://www.google.com.do/search*"
      "https://www.google.dz/search*"
      "https://www.google.com.ec/search*"
      "https://www.google.ee/search*"
      "https://www.google.com.eg/search*"
      "https://www.google.es/search*"
      "https://www.google.com.et/search*"
      "https://www.google.fi/search*"
      "https://www.google.com.fj/search*"
      "https://www.google.fm/search*"
      "https://www.google.fr/search*"
      "https://www.google.ga/search*"
      "https://www.google.ge/search*"
      "https://www.google.gg/search*"
      "https://www.google.com.gh/search*"
      "https://www.google.com.gi/search*"
      "https://www.google.gl/search*"
      "https://www.google.gm/search*"
      "https://www.google.gr/search*"
      "https://www.google.com.gt/search*"
      "https://www.google.gy/search*"
      "https://www.google.com.hk/search*"
      "https://www.google.hn/search*"
      "https://www.google.hr/search*"
      "https://www.google.ht/search*"
      "https://www.google.hu/search*"
      "https://www.google.co.id/search*"
      "https://www.google.ie/search*"
      "https://www.google.co.il/search*"
      "https://www.google.im/search*"
      "https://www.google.co.in/search*"
      "https://www.google.iq/search*"
      "https://www.google.is/search*"
      "https://www.google.it/search*"
      "https://www.google.je/search*"
      "https://www.google.com.jm/search*"
      "https://www.google.jo/search*"
      "https://www.google.co.jp/search*"
      "https://www.google.co.ke/search*"
      "https://www.google.com.kh/search*"
      "https://www.google.ki/search*"
      "https://www.google.kg/search*"
      "https://www.google.co.kr/search*"
      "https://www.google.com.kw/search*"
      "https://www.google.kz/search*"
      "https://www.google.la/search*"
      "https://www.google.com.lb/search*"
      "https://www.google.li/search*"
      "https://www.google.lk/search*"
      "https://www.google.co.ls/search*"
      "https://www.google.lt/search*"
      "https://www.google.lu/search*"
      "https://www.google.lv/search*"
      "https://www.google.com.ly/search*"
      "https://www.google.co.ma/search*"
      "https://www.google.md/search*"
      "https://www.google.me/search*"
      "https://www.google.mg/search*"
      "https://www.google.mk/search*"
      "https://www.google.ml/search*"
      "https://www.google.com.mm/search*"
      "https://www.google.mn/search*"
      "https://www.google.ms/search*"
      "https://www.google.com.mt/search*"
      "https://www.google.mu/search*"
      "https://www.google.mv/search*"
      "https://www.google.mw/search*"
      "https://www.google.com.mx/search*"
      "https://www.google.com.my/search*"
      "https://www.google.co.mz/search*"
      "https://www.google.com.na/search*"
      "https://www.google.com.ng/search*"
      "https://www.google.com.ni/search*"
      "https://www.google.ne/search*"
      "https://www.google.nl/search*"
      "https://www.google.no/search*"
      "https://www.google.com.np/search*"
      "https://www.google.nr/search*"
      "https://www.google.nu/search*"
      "https://www.google.co.nz/search*"
      "https://www.google.com.om/search*"
      "https://www.google.com.pa/search*"
      "https://www.google.com.pe/search*"
      "https://www.google.com.pg/search*"
      "https://www.google.com.ph/search*"
      "https://www.google.com.pk/search*"
      "https://www.google.pl/search*"
      "https://www.google.pn/search*"
      "https://www.google.com.pr/search*"
      "https://www.google.ps/search*"
      "https://www.google.pt/search*"
      "https://www.google.com.py/search*"
      "https://www.google.com.qa/search*"
      "https://www.google.ro/search*"
      "https://www.google.ru/search*"
      "https://www.google.rw/search*"
      "https://www.google.com.sa/search*"
      "https://www.google.com.sb/search*"
      "https://www.google.sc/search*"
      "https://www.google.se/search*"
      "https://www.google.com.sg/search*"
      "https://www.google.sh/search*"
      "https://www.google.si/search*"
      "https://www.google.sk/search*"
      "https://www.google.com.sl/search*"
      "https://www.google.sn/search*"
      "https://www.google.so/search*"
      "https://www.google.sm/search*"
      "https://www.google.sr/search*"
      "https://www.google.st/search*"
      "https://www.google.com.sv/search*"
      "https://www.google.td/search*"
      "https://www.google.tg/search*"
      "https://www.google.co.th/search*"
      "https://www.google.com.tj/search*"
      "https://www.google.tl/search*"
      "https://www.google.tm/search*"
      "https://www.google.tn/search*"
      "https://www.google.to/search*"
      "https://www.google.com.tr/search*"
      "https://www.google.tt/search*"
      "https://www.google.com.tw/search*"
      "https://www.google.co.tz/search*"
      "https://www.google.com.ua/search*"
      "https://www.google.co.ug/search*"
      "https://www.google.co.uk/search*"
      "https://www.google.com.uy/search*"
      "https://www.google.co.uz/search*"
      "https://www.google.com.vc/search*"
      "https://www.google.co.ve/search*"
      "https://www.google.vg/search*"
      "https://www.google.co.vi/search*"
      "https://www.google.com.vn/search*"
      "https://www.google.vu/search*"
      "https://www.google.ws/search*"
      "https://www.google.rs/search*"
      "https://www.google.co.za/search*"
      "https://www.google.co.zm/search*"
      "https://www.google.co.zw/search*"
      "https://www.google.cat/search*"
    ];
    "stylus" = [
      "alarms"
      "contextMenus"
      "storage"
      "tabs"
      "unlimitedStorage"
      "webNavigation"
      "webRequest"
      "webRequestBlocking"
      "<all_urls>"
      "https://userstyles.org/*"
    ];
    "tampermonkey" = [
      "alarms"
      "notifications"
      "tabs"
      "idle"
      "webNavigation"
      "webRequest"
      "webRequestBlocking"
      "unlimitedStorage"
      "storage"
      "contextMenus"
      "clipboardWrite"
      "cookies"
      "downloads"
      "<all_urls>"
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
      extensions.force = true;
      extensions.settings = {
        "uBlock0@raymondhill.net".settings = {
          "selectedFilterLists" = [
            "user-filters"
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-unbreak"
            "ublock-quick-fixes"
            "easylist"
            "easyprivacy"
            "urlhaus-1"
            "plowe-0"
          ];
          dynamicFilteringString = ''
            behind-the-scene * * noop 
            behind-the-scene * inline-script noop 
            behind-the-scene * 1p-script noop 
            behind-the-scene * 3p-script noop 
            behind-the-scene * 3p-frame noop 
            behind-the-scene * image noop 
            behind-the-scene * 3p noop 
            * * 3p block 
            bsky.app bsky-api-public.b-cdn.net * noop 
            bsky.app bsky-web.b-cdn.net * noop 
            bsky.app bsky.social * noop 
            akko.chir.rs assets-chir-rs.b-cdn.net * noop 
            akko.chir.rs mediaproxy-chir-rs.b-cdn.net * noop 
            bsky.app bsky.b-cdn.net * noop 
            bsky.app host.bsky.network * noop 
            github.com githubassets.com * noop 
            github.com avatars.githubusercontent.com * noop
            www.icy-veins.com etro.gg * noop
          '';
        };
      };
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
