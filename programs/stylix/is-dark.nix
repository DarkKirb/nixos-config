{ lib, config, ... }:
let
  rgbToFloat = r: if r == "255" then 1.0 else (lib.toInt r) / 256.0;
  luma =
    0.2126 * rgbToFloat config.lib.stylix.colors.base00-rgb-r
    + 0.7152 * rgbToFloat config.lib.stylix.colors.base00-rgb-g
    + 0.0722 * rgbToFloat config.lib.stylix.colors.base00-rgb-b;
in
{
  options.polarity = lib.mkOption {
    description = "what polarity to use";
    type = lib.types.enum [
      "dark"
      "light"
      "either"
    ];
  };
  options.isLightTheme = lib.mkEnableOption "Set to true on light themes, false on dark themes.";
  config.isLightTheme = lib.mkDefault (
    {
      dark = false;
      light = true;
      either = luma > 0.5;
    }
    .${config.polarity}
  );
}
