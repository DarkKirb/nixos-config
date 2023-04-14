{pkgs, ...}: {
  output.path.path = with pkgs; [universal-ctags];
  output.plugins = with pkgs.vimPlugins; [vista-vim];
  vim.keybindings.keybindings."<Leader>".t = {
    command = "<cmd>Vista!!<CR>";
    options.silent = true;
    label = "Open vista";
  };
}
