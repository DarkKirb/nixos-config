{pkgs, ...}: {
  programs.firefox = {
    package = pkgs.firefox-wayland;
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      clearurls
      consent-o-matic
      darkreader
      decentraleyes
      don-t-fuck-with-paste
      i-dont-care-about-cookies
      keepassxc-browser
      privacy-badger
      privacy-possum
      sponsorblock
      stylus
      tree-style-tab
      ublock-origin
      unpaywall
    ];
    profiles = {
      unhardened = {
        id = 1;
      };
      default = {
        userChrome = ''
          /* Hide tab bar in FF Quantum */
          @-moz-document url("chrome://browser/content/browser.xul") {
            #TabsToolbar {
              visibility: collapse !important;
              margin-bottom: 21px !important;
            }

            #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
              visibility: collapse !important;
            }
          }
        '';
        settings = {
          "browser.display.use_document_fonts" = 0;
          "font.default.x-western" = "sans-serif";
          "font.name-list.monospace.x-western" = "monospace, nasin-nanpa";
          "font.name-list.sans-serif.x-western" = "sans-serif, nasin-nanpa";
          "font.name-list.serif.x-western" = "sans-serif, nasin-nanpa";
        };
        id = 0;
      };
    };
  };
}
