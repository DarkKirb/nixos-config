{ pkgs, ... }:

{
    vim.g = {
      NERDCreateDefaultMappings = 0;
      NERDSpaceDelims = 1;
      NERDTrimTrailingWhitespace = 1;
    };

    output.plugins = with pkgs.vimPlugins; [ nerdcommenter ];
  }
