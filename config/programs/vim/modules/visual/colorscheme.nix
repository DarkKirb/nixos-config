{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [catppuccin-nvim];
  plugin.setup.catppuccin = {
    flavour = "mocha";
    transparent_background = true;
    integrations = {
      dashboard = true;
      gitsigns = true;
      hop = true;
      markdown = true;
      cmp = true;
      native_lsp = {
        enabled = true;
      };
      nvimtree = true;
      telescope = true;
    };
  };
  output.extraConfig = ''
    colorscheme catppuccin
    highlight CatppuccinRosewater guifg=#f5e0dc gui=nocombine
    highlight CatppuccinFlamingo guifg=#f2cdcd gui=nocombine
    highlight CatppuccinPink guifg=#f5c2e7 gui=nocombine
    highlight CatppuccinMauve guifg=#cba6f7 gui=nocombine
    highlight CatppuccinRed guifg=#f38ba8 gui=nocombine
    highlight CatppuccinMaroon guifg=#eba0ac gui=nocombine
    highlight CatppuccinPeach guifg=#fab387 gui=nocombine
    highlight CatppuccinYellow guifg=#f9e2af gui=nocombine
    highlight CatppuccinGreen guifg=#a6e3a1 gui=nocombine
    highlight CatppuccinTeal guifg=#94e2d5 gui=nocombine
    highlight CatppuccinSky guifg=#89dceb gui=nocombine
    highlight CatppuccinSapphire guifg=#74c7ec gui=nocombine
    highlight CatppuccinBlue guifg=#89b4fa gui=nocombine
    highlight CatppuccinLavender guifg=#b4befe gui=nocombine
  '';
}
