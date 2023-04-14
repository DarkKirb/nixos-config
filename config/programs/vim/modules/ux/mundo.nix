{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [vim-mundo];
  vim.keybindings.keybindings."<Space>".u = {
    command = "<Cmd>MundoToggle<CR>";
    options.silent = true;
    label = "Toggle mundo";
  };
}
