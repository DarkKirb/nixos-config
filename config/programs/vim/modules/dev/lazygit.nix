{ pkgs, lib, config, ... }:

{
  vim.keybindings.keybindings-shortened."<leader>gg" = {
    command = ":LazyGit<CR>";
    label = "lazygit";
  };

  output.plugins = with pkgs.vimPlugins; [ lazygit-nvim ];
  output.path.path = with pkgs; [ lazygit git ];
}
