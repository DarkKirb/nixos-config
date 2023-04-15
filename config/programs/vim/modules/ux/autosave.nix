{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [vim-auto-save];
  vim.g.auto_save = 1;
}
