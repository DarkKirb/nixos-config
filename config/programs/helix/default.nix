{
  helix,
  system,
  pkgs,
  ...
}: {
  imports = [
    ./languages.nix
  ];
  programs.helix = {
    enable = true;
    package = helix.packages.${system}.helix;
    settings = {
      theme = "gruvbox";
      editor = {
        line-number = "relative";
      };
    };
    themes = {
      gruvbox = {
        # Author : Jakub Bartodziej <kubabartodziej@gmail.com>
        # The theme uses the gruvbox dark palette with standard contrast: github.com/morhetz/gruvbox
        "attribute" = "aqua1";
        "keyword" = {fg = "red1";};
        "keyword.directive" = "red0";
        "namespace" = "aqua1";
        "punctuation" = "orange1";
        "punctuation.delimiter" = "orange1";
        "operator" = "purple1";
        "special" = "purple0";
        "variable.other.member" = "blue1";
        "variable" = "fg1";
        "variable.builtin" = "orange1";
        "variable.parameter" = "fg2";
        "type" = "yellow1";
        "type.builtin" = "yellow1";
        "constructor" = {
          fg = "purple1";
          modifiers = ["bold"];
        };
        "function" = {
          fg = "green1";
          modifiers = ["bold"];
        };
        "function.macro" = "aqua1";
        "function.builtin" = "yellow1";
        "tag" = "red1";
        "comment" = {
          fg = "gray1";
          modifiers = ["italic"];
        };
        "constant" = {fg = "purple1";};
        "constant.builtin" = {
          fg = "purple1";
          modifiers = ["bold"];
        };
        "string" = "green1";
        "constant.numeric" = "purple1";
        "constant.character.escape" = {
          fg = "fg2";
          modifiers = ["bold"];
        };
        "label" = "aqua1";
        "module" = "aqua1";

        "diff.plus" = "green1";
        "diff.delta" = "orange1";
        "diff.minus" = "red1";

        "warning" = {
          fg = "orange1";
          bg = "bg1";
        };
        "error" = {
          fg = "red1";
          bg = "bg1";
        };
        "info" = {
          fg = "aqua1";
          bg = "bg1";
        };
        "hint" = {
          fg = "blue1";
          bg = "bg1";
        };

        "ui.background" = {bg = "bg0";};
        "ui.linenr" = {fg = "bg4";};
        "ui.linenr.selected" = {fg = "yellow1";};
        "ui.cursorline" = {bg = "bg1";};
        "ui.statusline" = {
          fg = "fg1";
          bg = "bg2";
        };
        "ui.statusline.normal" = {
          fg = "fg1";
          bg = "bg2";
        };
        "ui.statusline.insert" = {
          fg = "fg1";
          bg = "blue0";
        };
        "ui.statusline.select" = {
          fg = "fg1";
          bg = "orange0";
        };
        "ui.statusline.inactive" = {
          fg = "fg4";
          bg = "bg1";
        };
        "ui.popup" = {bg = "bg1";};
        "ui.window" = {bg = "bg1";};
        "ui.help" = {
          bg = "bg1";
          fg = "fg1";
        };
        "ui.text" = {fg = "fg1";};
        "ui.text.focus" = {fg = "fg1";};
        "ui.selection" = {
          bg = "bg3";
          modifiers = ["reversed"];
        };
        "ui.cursor.primary" = {modifiers = ["reversed"];};
        "ui.cursor.match" = {bg = "bg2";};
        "ui.menu" = {
          fg = "fg1";
          bg = "bg2";
        };
        "ui.menu.selected" = {
          fg = "bg2";
          bg = "blue1";
          modifiers = ["bold"];
        };
        "ui.virtual.whitespace" = "bg2";
        "ui.virtual.ruler" = {bg = "bg1";};

        "diagnostic" = {modifiers = ["underlined"];};

        "markup.heading" = "aqua1";
        "markup.bold" = {modifiers = ["bold"];};
        "markup.italic" = {modifiers = ["italic"];};
        "markup.link.url" = {
          fg = "green1";
          modifiers = ["underlined"];
        };
        "markup.link.text" = "red1";
        "markup.raw" = "red1";
        palette = {
          bg0 = "#282828"; # main background
          bg1 = "#3c3836";
          bg2 = "#504945";
          bg3 = "#665c54";
          bg4 = "#7c6f64";

          fg0 = "#fbf1c7";
          fg1 = "#ebdbb2"; # main foreground
          fg2 = "#d5c4a1";
          fg3 = "#bdae93";
          fg4 = "#a89984"; # gray0

          gray0 = "#a89984";
          gray1 = "#928374";

          red0 = "#cc241d"; # neutral
          red1 = "#fb4934"; # bright
          green0 = "#98971a";
          green1 = "#b8bb26";
          yellow0 = "#d79921";
          yellow1 = "#fabd2f";
          blue0 = "#458588";
          blue1 = "#83a598";
          purple0 = "#b16286";
          purple1 = "#d3869b";
          aqua0 = "#689d6a";
          aqua1 = "#8ec07c";
          orange0 = "#d65d0e";
          orange1 = "#fe8019";
        };
      };
    };
  };
}
