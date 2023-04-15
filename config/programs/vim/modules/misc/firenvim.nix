{
  pkgs,
  config,
  ...
}: {
  output.plugins =
    if config.isDesktop
    then with pkgs.vimPlugins; [firenvim]
    else [];
  output.extraConfig =
    if config.isDesktop
    then ''
      silent call firenvim#install(0)
      lua << EOF
      if vim.g.started_by_firenvim then
        vim.o.showtabline = 0
        require("lualine").hide()
      end
      EOF
    ''
    else "";
  vim.opt.guifont = "Fira_Code_Mono_Nerd_Font_Mono:h9";
}
