{ pkgs, ... }: {
  output.plugins = with pkgs.vimPlugins; [
    nvim-web-devicons
  ];
}
