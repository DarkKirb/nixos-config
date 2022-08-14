{pkgs, ...}: {
  vim.opt.showmode = false;

  vim.g.lightline = {
    active = {
      left = [["mode" "paste"] ["readonly" "filename" "modified"]];
      right = [
        ["lineinfo"]
        ["percent"]
        ["fileformat" "fileencoding" "filetype"]
      ];
    };
    separator = {
      left = "";
      right = "";
    };
    subseparator = {
      left = "";
      right = "";
    };
    enable = {
      tabline = 0;
    };
  };

  output.plugins = with pkgs.vimPlugins; [lightline-vim];
}
