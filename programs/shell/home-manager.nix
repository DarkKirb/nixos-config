{ pkgs, ... }:
{
  home.packages = [ pkgs.hyfetch ];
  xdg.configFile."hyfetch.json".text = builtins.toJSON {
    preset = "nonhuman-unity";
    mode = "rgb";
    light_dark = "dark";
    lightness = 0.65;
    color_align = {
      mode = "vertical";
      custom_colors = [ ];
      fore_back = [ ];
    };
    backend = "neofetch";
    args = null;
    distro = null;
    pride_month_shown = [ ];
    pride_month_disable = false;
  };
}
