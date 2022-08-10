{ pkgs, ... }: {
  output.plugins = with pkgs.vimPlugins; [
    vim-web-devicons
  ];
}
