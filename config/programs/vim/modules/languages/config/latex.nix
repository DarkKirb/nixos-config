# Copied from https://github.com/splintah/configuration/blob/7c7bfc2065b1bda84222e8adc9d238eca4ada0e0/vim/plugin/vimtex.vim
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  vim.g = {
    vimtex_quickfix_open_on_warning = 0;

    vimtex_compiler_latexmk = {
      backend = "nvim";
      background = 1;
      build_dir = "";
      callback = 1;
      continuous = 1;
      executable = "latexmk";
      options = [
        "-xelatex"
        "-verbose"
        "-file-line-error"
        "-synctex=1"
        "-interaction=nonstopmode"
      ];
    };
    vimtex_compiler_latexmk_engines = {
      "_" = "-xelatex";
      "pdflatex" = "-pdf";
      "lualatex" = "-lualatex";
      "xelatex" = "-xelatex";
      "context (pdftex)" = "-pdf -pdflatex=texexec";
      "context (luatex)" = "-pdf -pdflatex=context";
      "context (xetex)" = ''-pdf -pdflatex="texexec --xtx"'';
    };

    tex_flavor = "latex";
    vimtex_view_general_viewer = "zathura";
  };

  output.plugins = with pkgs.vimPlugins; [vimtex];

  output.path.path = with pkgs; [
    pkgs.texlive.combined.scheme-full
    procps
    zathura
  ];
}
