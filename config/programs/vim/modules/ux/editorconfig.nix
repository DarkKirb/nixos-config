{pkgs, ...}: {output.plugins = with pkgs.vimPlugins; [editorconfig-nvim];}
