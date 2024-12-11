{ lib, config, ... }:
let
  rgbToFloat = r: if r == "255" then 1.0 else (lib.toInt r) / 256.0;
  luma =
    0.2126 * rgbToFloat config.lib.stylix.colors.base00-rgb-r
    + 0.7152 * rgbToFloat config.lib.stylix.colors.base00-rgb-g
    + 0.0722 * rgbToFloat config.lib.stylix.colors.base00-rgb-b;
  configFile = {
    settings_defaults = {
      default_theme = "custom-Stylix";
      custom_themes = [
        {
          name = "Stylix";
          is_dark = luma < 0.5;
          colors = with config.lib.stylix.colors.withHashtag; {
            "accent-color" = base07;
            "primary-color" = base07;
            "warning-color" = base08;
            "alert" = base0A;
            "sidebar-color" = base00;
            "roomlist-background-color" = base01;
            "roomlist-text-color" = base05;
            "roomlist-text-secondary-color" = base03;
            "roomlist-highlights-color" = base03;
            "roomlist-separator-color" = base04;
            "timeline-background-color" = base00;
            "timeline-text-color" = base05;
            "secondary-content" = base05;
            "tertiary-content" = base05;
            "timeline-text-secondary-color" = base08;
            "timeline-highlights-color" = base01;
            "reaction-row-button-selected-bg-color" = base03;
            "menu-selected-color" = base03;
            "focus-bg-color" = base01;
            "room-highlight-color" = base01;
            "togglesw-off-color" = base03;
            "other-user-pill-bg-color" = base01;
            "username-colors" = [
              base08
              base09
              base0A
              base0B
              base0C
              base0D
              base0E
              base0F
            ];
            "avatar-background-colors" = [
              base08
              base09
              base0A
              base0B
              base0C
              base0D
              base0E
              base0F
            ];
          };
        }
      ];
    };
  };
in
{
  home.activation.elementConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -svf ${builtins.toFile "config.json" (builtins.toJSON configFile)} ~/.config/Element/config.json
  '';
}
