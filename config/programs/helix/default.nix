{
  helix,
  system,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    package = helix.packages.${system}.helix;
    languages = [
      {
        name = "rust";
        debugger = {
          command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
          name = "codelldb";
          port-arg = "--port {}";
          transport = "tcp";
          templates = [
            {
              name = "binary";
              request = "launch";
              completion = [
                {
                  completion = "filename";
                  name = "binary";
                }
              ];
              args = [
                {
                  program = "{0}";
                  runInTerminal = true;
                }
              ];
            }
          ];
        };
        language-server.command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      }
      {
        name = "toml";
        language-server = {
          command = "${pkgs.taplo}/bin/taplo";
          args = ["lsp" "stdio"];
        };
      }
      {
        name = "elixir";
        language-server.command = "${pkgs.elixir_ls}/bin/elixir-ls";
      }
      {
        name = "json";
        language-server = {
          command = "${pkgs.nodePackages.vscode-json-languageserver}/bin/vscode-json-languageserver";
          args = ["--stdin"];
        };
      }
      {
        name = "c";
        language-server.command = "${pkgs.llvmPackages_latest.clang-unwrapped}/bin/clangd";
      }
      {
        name = "cpp";
        language-server.command = "${pkgs.llvmPackages_latest.clang-unwrapped}/bin/clangd";
      }
      {
        name = "javascript";
        language-server = {
          command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
          args = ["--stdio"];
          language-id = "javascript";
        };
      }
      {
        name = "jsx";
        language-server = {
          command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
          args = ["--stdio"];
          language-id = "javascriptreact";
        };
      }
      {
        name = "typescript";
        language-server = {
          command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
          args = ["--stdio"];
          language-id = "typescript";
        };
      }
      {
        name = "typescriptreact";
        language-server = {
          command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
          args = ["--stdio"];
          language-id = "typescriptreact";
        };
      }
      {
        name = "css";
        language-server = {
          command = "${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver";
          args = ["--stdio"];
        };
      }
      {
        name = "scss";
        language-server = {
          command = "${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver";
          args = ["--stdio"];
        };
      }
      {
        name = "html";
        language-server = {
          command = "${pkgs.nodePackages.vscode-html-languageserver-bin}/bin/html-languageserver";
          args = ["--stdio"];
        };
      }
      {
        name = "python";
        language-server.command = "${pkgs.python3Packages.python-lsp-server}/bin/pylsp";
      }
      {
        name = "nix";
        language-server.command = "${pkgs.rnix-lsp}/bin/rnix-lsp";
      }
      {
        name = "bash";
        language-server = {
          command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
          args = ["start"];
        };
      }
      {
        name = "latex";
        language-server.command = "${pkgs.texlab}/bin/texlab";
      }
      {
        name = "java";
        language-server.command = "${pkgs.jdt-language-server}/bin/jdt-language-server";
      }
      {
        name = "vue";
        language-server.command = "${pkgs.nodePackages.vls}/bin/vls";
      }
      {
        name = "yaml";
        language-server = {
          command = "${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server";
          args = ["--stdin"];
        };
      }
    ];
    settings = {
      lsp.display-messages = true;
      theme = "gruvbox";
    };
    themes = {
      gruvbox = {
        bg0 = "#1d2021";
        bg1 = "#282828";
        bg2 = "#282828";
        bg3 = "#3c3836";
        bg4 = "#3c3836";
        bg5 = "#504945";
        bg_statusline1 = "#282828";
        bg_statusline2 = "#32302f";
        bg_statusline3 = "#504945";
        bg_diff_green = "#32361a";
        bg_visual_green = "#333e34";
        bg_diff_red = "#3c1f1e";
        bg_visual_red = "#442e2d";
        bg_diff_blue = "#0d3138";
        bg_visual_blue = "#2e3b3b";
        bg_visual_yellow = "#473c29";
        bg_current_word = "#32302f";

        fg0 = "#d4be98";
        fg1 = "#ddc7a1";
        red = "#ea6962";
        orange = "#e78a4e";
        yellow = "#d8a657";
        green = "#a9b665";
        aqua = "#89b482";
        blue = "#7daea3";
        purple = "#d3869b";
        bg_red = "#ea6962";
        bg_green = "#a9b665";
        bg_yellow = "#d8a657";

        grey0 = "#7c6f64";
        grey1 = "#928374";
        grey2 = "#a89984";
      };
    };
  };
}
