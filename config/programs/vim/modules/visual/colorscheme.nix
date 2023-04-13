{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [catppuccin-nvim];
  plugin.setup.catppuccin = {
    flavour = "mocha";
    transparent_background = true;
  };
  output.extraConfig = "colorscheme catppuccin";
}
