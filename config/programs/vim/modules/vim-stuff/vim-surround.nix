{ pkgs, ... }:

{
  output.plugins = with pkgs.vimPlugins; [ vim-surround ];
}
