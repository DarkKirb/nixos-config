{pkgs, ...}: {
  programs.helix.languages = [
    {
      auto-format = true;
      auto-pairs = {
        "\"" = "\"";
        "(" = ")";
        "[" = "]";
        "`" = "`";
        "{" = "}";
      };
      comment-token = "//";
      debugger = {
        command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
        name = "lldb-vscode";
        templates = [
          {
            args = {program = "{0}";};
            completion = [
              {
                completion = "filename";
                name = "binary";
              }
            ];
            name = "binary";
            request = "launch";
          }
          {
            args = {
              program = "{0}";
              runInTerminal = true;
            };
            completion = [
              {
                completion = "filename";
                name = "binary";
              }
            ];
            name = "binary (terminal)";
            request = "launch";
          }
          {
            args = {pid = "{0}";};
            completion = ["pid"];
            name = "attach";
            request = "attach";
          }
          {
            args = {attachCommands = ["platform select remote-gdb-server" "platform connect {0}" "file {1}" "attach {2}"];};
            completion = [
              {
                default = "connect://localhost:3333";
                name = "lldb connect url";
              }
              {
                completion = "filename";
                name = "file";
              }
              "pid"
            ];
            name = "gdbserver attach";
            request = "attach";
          }
        ];
        transport = "stdio";
      };
      file-types = ["rs"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "rust";
      language-server = {command = "${pkgs.rust-analyzer}/bin/rust-analyzer";};
      name = "rust";
      roots = ["Cargo.toml" "Cargo.lock"];
      scope = "source.rust";
    }
    {
      comment-token = "#";
      file-types = ["toml"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "toml";
      language-server = {
        args = ["lsp" "stdio"];
        command = "${pkgs.rust-analyzer}/bin/taplo";
      };
      name = "toml";
      roots = [];
      scope = "source.toml";
    }
    {
      comment-token = "#";
      file-types = ["awk" "gawk" "nawk" "mawk"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "awk";
      language-server = {command = "awk-language-server";};
      name = "awk";
      roots = [];
      scope = "source.awk";
    }
    {
      comment-token = "//";
      file-types = ["proto"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "protobuf";
      name = "protobuf";
      roots = [];
      scope = "source.proto";
    }
    {
      comment-token = "#";
      config = {elixirLS = {dialyzerEnabled = false;};};
      file-types = ["ex" "exs" "mix.lock"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "(elixir|ex)";
      language-server.command = "${pkgs.elixir_ls}/bin/elixir-ls";
      name = "elixir";
      roots = [];
      scope = "source.elixir";
      shebangs = ["elixir"];
    }
    {
      comment-token = "#";
      file-types = ["fish"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "fish";
      name = "fish";
      roots = [];
      scope = "source.fish";
      shebangs = ["fish"];
    }
    {
      comment-token = "//";
      file-types = ["mint"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "mint";
      language-server = {
        args = ["ls"];
        command = "mint";
      };
      name = "mint";
      roots = [];
      scope = "source.mint";
      shebangs = [];
    }
    {
      auto-format = true;
      config = {provideFormatter = true;};
      file-types = ["json"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "json";
      language-server = {
        args = ["--stdio"];
        command = "${pkgs.nodePackages.vscode-json-languageserver}/bin/vscode-json-languageserver";
      };
      name = "json";
      roots = [];
      scope = "source.json";
    }
    {
      comment-token = "//";
      debugger = {
        command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
        name = "lldb-vscode";
        templates = [
          {
            args = {
              console = "internalConsole";
              program = "{0}";
            };
            completion = [
              {
                completion = "filename";
                name = "binary";
              }
            ];
            name = "binary";
            request = "launch";
          }
          {
            args = {
              console = "internalConsole";
              pid = "{0}";
            };
            completion = ["pid"];
            name = "attach";
            request = "attach";
          }
          {
            args = {
              attachCommands = ["platform select remote-gdb-server" "platform connect {0}" "file {1}" "attach {2}"];
              console = "internalConsole";
            };
            completion = [
              {
                default = "connect://localhost:3333";
                name = "lldb connect url";
              }
              {
                completion = "filename";
                name = "file";
              }
              "pid"
            ];
            name = "gdbserver attach";
            request = "attach";
          }
        ];
        transport = "stdio";
      };
      file-types = ["c"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "c";
      language-server.command = "${pkgs.llvmPackages_latest.clang-unwrapped}/bin/clangd";
      name = "c";
      roots = [];
      scope = "source.c";
    }
    {
      comment-token = "//";
      debugger = {
        command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
        name = "lldb-vscode";
        templates = [
          {
            args = {
              console = "internalConsole";
              program = "{0}";
            };
            completion = [
              {
                completion = "filename";
                name = "binary";
              }
            ];
            name = "binary";
            request = "launch";
          }
          {
            args = {
              console = "internalConsole";
              pid = "{0}";
            };
            completion = ["pid"];
            name = "attach";
            request = "attach";
          }
          {
            args = {
              attachCommands = ["platform select remote-gdb-server" "platform connect {0}" "file {1}" "attach {2}"];
              console = "internalConsole";
            };
            completion = [
              {
                default = "connect://localhost:3333";
                name = "lldb connect url";
              }
              {
                completion = "filename";
                name = "file";
              }
              "pid"
            ];
            name = "gdbserver attach";
            request = "attach";
          }
        ];
        transport = "stdio";
      };
      file-types = ["cc" "hh" "cpp" "hpp" "h" "ipp" "tpp" "cxx" "hxx" "ixx" "txx" "ino"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "cpp";
      language-server.command = "${pkgs.llvmPackages_latest.clang-unwrapped}/bin/clangd";
      name = "cpp";
      roots = [];
      scope = "source.cpp";
    }
    {
      comment-token = "//";
      file-types = ["cs"];
      indent = {
        tab-width = 4;
        unit = "\t";
      };
      injection-regex = "c-?sharp";
      language-server = {
        args = ["--languageserver"];
        command = "OmniSharp";
      };
      name = "c-sharp";
      roots = ["sln" "csproj"];
      scope = "source.csharp";
    }
    {
      auto-format = true;
      comment-token = "//";
      debugger = {
        args = ["dap"];
        command = "dlv";
        name = "go";
        port-arg = "-l 127.0.0.1:{}";
        templates = [
          {
            args = {
              mode = "debug";
              program = "{0}";
            };
            completion = [
              {
                completion = "filename";
                default = ".";
                name = "entrypoint";
              }
            ];
            name = "source";
            request = "launch";
          }
          {
            args = {
              mode = "exec";
              program = "{0}";
            };
            completion = [
              {
                completion = "filename";
                name = "binary";
              }
            ];
            name = "binary";
            request = "launch";
          }
          {
            args = {
              mode = "test";
              program = "{0}";
            };
            completion = [
              {
                completion = "directory";
                default = ".";
                name = "tests";
              }
            ];
            name = "test";
            request = "launch";
          }
          {
            args = {
              mode = "local";
              processId = "{0}";
            };
            completion = ["pid"];
            name = "attach";
            request = "attach";
          }
        ];
        transport = "tcp";
      };
      file-types = ["go"];
      indent = {
        tab-width = 4;
        unit = "\t";
      };
      injection-regex = "go";
      language-server = {command = "gopls";};
      name = "go";
      roots = ["Gopkg.toml" "go.mod"];
      scope = "source.go";
    }
    {
      auto-format = true;
      comment-token = "//";
      file-types = ["go.mod"];
      indent = {
        tab-width = 4;
        unit = "\t";
      };
      injection-regex = "gomod";
      language-server = {command = "gopls";};
      name = "gomod";
      roots = [];
      scope = "source.gomod";
    }
    {
      comment-token = "//";
      file-types = ["gotmpl"];
      indent = {
        tab-width = 2;
        unit = " ";
      };
      injection-regex = "gotmpl";
      language-server = {command = "gopls";};
      name = "gotmpl";
      roots = [];
      scope = "source.gotmpl";
    }
    {
      auto-format = true;
      comment-token = "//";
      file-types = ["go.work"];
      indent = {
        tab-width = 4;
        unit = "\t";
      };
      injection-regex = "gowork";
      language-server = {command = "gopls";};
      name = "gowork";
      roots = [];
      scope = "source.gowork";
    }
    {
      comment-token = "//";
      debugger = {
        name = "node-debug2";
        quirks = {absolute-paths = true;};
        templates = [
          {
            args = {program = "{0}";};
            completion = [
              {
                completion = "filename";
                default = "index.js";
                name = "main";
              }
            ];
            name = "source";
            request = "launch";
          }
        ];
        transport = "stdio";
      };
      file-types = ["js" "mjs" "cjs"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "(js|javascript)";
      language-server = {
        args = ["--stdio"];
        command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
        language-id = "javascript";
      };
      name = "javascript";
      roots = [];
      scope = "source.js";
      shebangs = ["node"];
    }
    {
      comment-token = "//";
      file-types = ["jsx"];
      grammar = "javascript";
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "jsx";
      language-server = {
        args = ["--stdio"];
        command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
        language-id = "javascriptreact";
      };
      name = "jsx";
      roots = [];
      scope = "source.jsx";
    }
    {
      file-types = ["ts"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "(ts|typescript)";
      language-server = {
        args = ["--stdio"];
        command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
        language-id = "typescript";
      };
      name = "typescript";
      roots = [];
      scope = "source.ts";
      shebangs = [];
    }
    {
      file-types = ["tsx"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "(tsx)";
      language-server = {
        args = ["--stdio"];
        command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
        language-id = "typescriptreact";
      };
      name = "tsx";
      roots = [];
      scope = "source.tsx";
    }
    {
      file-types = ["css" "scss"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "css";
      language-server = {
        args = ["--stdio"];
        command = "${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver";
      };
      name = "css";
      roots = [];
      scope = "source.css";
    }
    {
      file-types = ["scss"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "scss";
      language-server = {
        args = ["--stdio"];
        command = "${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver";
      };
      name = "scss";
      roots = [];
      scope = "source.scss";
    }
    {
      auto-format = true;
      config = {provideFormatter = true;};
      file-types = ["html"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "html";
      language-server = {
        args = ["--stdio"];
        command = "${pkgs.nodePackages.vscode-html-languageserver-bin}/bin/html-languageserver";
      };
      name = "html";
      roots = [];
      scope = "text.html.basic";
    }
    {
      comment-token = "#";
      file-types = ["py"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "python";
      language-server.command = "${pkgs.python3Packages.python-lsp-server}/bin/pylsp";
      name = "python";
      roots = [];
      scope = "source.python";
      shebangs = ["python"];
    }
    {
      comment-token = "#";
      file-types = ["ncl"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "nickel";
      language-server = {command = "nls";};
      name = "nickel";
      roots = [];
      scope = "source.nickel";
      shebangs = [];
    }
    {
      comment-token = "#";
      file-types = ["nix"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "nix";
      language-server.command = "${pkgs.rnix-lsp}/bin/rnix-lsp";
      name = "nix";
      roots = [];
      scope = "source.nix";
      shebangs = [];
    }
    {
      comment-token = "#";
      file-types = ["rb" "rake" "rakefile" "irb" "gemfile" "gemspec" "Rakefile" "Gemfile" "rabl" "jbuilder" "jb"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "ruby";
      language-server = {
        args = ["stdio"];
        command = "solargraph";
      };
      name = "ruby";
      roots = [];
      scope = "source.ruby";
      shebangs = ["ruby"];
    }
    {
      comment-token = "#";
      file-types = ["sh" "bash" "zsh" ".bash_login" ".bash_logout" ".bash_profile" ".bashrc" ".profile" ".zshenv" ".zlogin" ".zlogout" ".zprofile" ".zshrc" "APKBUILD" "PKGBUILD" "eclass" "ebuild" "bazelrc"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "(shell|bash|zsh|sh)";
      language-server = {
        args = ["start"];
        command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
      };
      name = "bash";
      roots = [];
      scope = "source.bash";
      shebangs = ["sh" "bash" "dash"];
    }
    {
      file-types = ["php" "inc"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "php";
      language-server = {
        args = ["--stdio"];
        command = "intelephense";
      };
      name = "php";
      roots = ["composer.json" "index.php"];
      scope = "source.php";
      shebangs = ["php"];
    }
    {
      file-types = ["twig"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "twig";
      name = "twig";
      roots = [];
      scope = "source.twig";
    }
    {
      comment-token = "%";
      file-types = ["tex"];
      indent = {
        tab-width = 4;
        unit = "\t";
      };
      injection-regex = "tex";
      language-server.command = "${pkgs.texlab}/bin/texlab";
      name = "latex";
      roots = [];
      scope = "source.tex";
    }
    {
      comment-token = "--";
      file-types = ["lean"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "lean";
      language-server = {
        args = ["--server"];
        command = "lean";
      };
      name = "lean";
      roots = ["lakefile.lean"];
      scope = "source.lean";
    }
    {
      comment-token = "#";
      file-types = ["jl"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "julia";
      language-server = {
        args = ["--startup-file=no" "--history-file=no" "--quiet" "-e" "using LanguageServer; runserver()"];
        command = "julia";
      };
      name = "julia";
      roots = [];
      scope = "source.julia";
    }
    {
      file-types = ["java"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "java";
      language-server = {command = "jdtls";};
      name = "java";
      roots = ["pom.xml"];
      scope = "source.java";
    }
    {
      comment-token = ";";
      file-types = ["ldg" "ledger" "journal"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "ledger";
      name = "ledger";
      roots = [];
      scope = "source.ledger";
    }
    {
      comment-token = ";";
      file-types = ["beancount" "bean"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "beancount";
      name = "beancount";
      roots = [];
      scope = "source.beancount";
    }
    {
      comment-token = "(**)";
      file-types = ["ml"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "ocaml";
      language-server = {command = "ocamllsp";};
      name = "ocaml";
      roots = [];
      scope = "source.ocaml";
      shebangs = [];
    }
    {
      comment-token = "(**)";
      file-types = ["mli"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      language-server = {command = "ocamllsp";};
      name = "ocaml-interface";
      roots = [];
      scope = "source.ocaml.interface";
      shebangs = [];
    }
    {
      comment-token = "--";
      file-types = ["lua"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      language-server = {
        args = [];
        command = "lua-language-server";
      };
      name = "lua";
      roots = [".luarc.json" ".luacheckrc" ".stylua.toml" "selene.toml" ".git"];
      scope = "source.lua";
      shebangs = ["lua"];
    }
    {
      file-types = ["svelte"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "svelte";
      language-server = {
        args = ["--stdio"];
        command = "svelteserver";
      };
      name = "svelte";
      roots = [];
      scope = "source.svelte";
    }
    {
      file-types = ["vue"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "vue";
      language-server.command = "${pkgs.nodePackages.vls}/bin/vls";
      name = "vue";
      roots = ["package.json" "vue.config.js"];
      scope = "source.vue";
    }
    {
      comment-token = "#";
      file-types = ["yml" "yaml"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "yml|yaml";
      language-server = {
        args = ["--stdio"];
        command = "${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server";
      };
      name = "yaml";
      roots = [];
      scope = "source.yaml";
    }
    {
      comment-token = "--";
      file-types = ["hs"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "haskell";
      language-server = {
        args = ["--lsp"];
        command = "haskell-language-server-wrapper";
      };
      name = "haskell";
      roots = ["Setup.hs" "stack.yaml" "*.cabal"];
      scope = "source.haskell";
    }
    {
      auto-format = true;
      comment-token = "//";
      file-types = ["zig"];
      formatter = {
        args = ["fmt" "--stdin"];
        command = "zig";
      };
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "zig";
      language-server = {command = "zls";};
      name = "zig";
      roots = ["build.zig"];
      scope = "source.zig";
    }
    {
      comment-token = "%";
      file-types = ["pl" "prolog"];
      language-server = {
        args = ["-g" "use_module(library(lsp_server))" "-g" "lsp_server:main" "-t" "halt" "--" "stdio"];
        command = "swipl";
      };
      name = "prolog";
      roots = [];
      scope = "source.prolog";
      shebangs = ["swipl"];
    }
    {
      comment-token = ";";
      file-types = ["scm"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "tsq";
      name = "tsq";
      roots = [];
      scope = "source.tsq";
    }
    {
      comment-token = "#";
      file-types = ["cmake" "CMakeLists.txt"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "cmake";
      language-server = {command = "cmake-language-server";};
      name = "cmake";
      roots = [];
      scope = "source.cmake";
    }
    {
      comment-token = "#";
      file-types = ["Makefile" "makefile" "mk" "justfile" ".justfile"];
      indent = {
        tab-width = 4;
        unit = "\t";
      };
      injection-regex = "(make|makefile|Makefile|mk|just)";
      name = "make";
      roots = [];
      scope = "source.make";
    }
    {
      comment-token = "//";
      file-types = ["glsl" "vert" "tesc" "tese" "geom" "frag" "comp"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "glsl";
      name = "glsl";
      roots = [];
      scope = "source.glsl";
    }
    {
      comment-token = "#";
      file-types = ["pl" "pm" "t"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      name = "perl";
      roots = [];
      scope = "source.perl";
      shebangs = ["perl"];
    }
    {
      comment-token = ";";
      file-types = ["rkt"];
      language-server = {
        args = ["-l" "racket-langserver"];
        command = "racket";
      };
      name = "racket";
      roots = [];
      scope = "source.rkt";
      shebangs = ["racket"];
    }
    {
      file-types = [];
      injection-regex = "comment";
      name = "comment";
      roots = [];
      scope = "scope.comment";
    }
    {
      comment-token = "//";
      file-types = ["wgsl"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      language-server = {command = "wgsl_analyzer";};
      name = "wgsl";
      roots = [];
      scope = "source.wgsl";
    }
    {
      comment-token = ";";
      file-types = ["ll"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "llvm";
      name = "llvm";
      roots = [];
      scope = "source.llvm";
    }
    {
      comment-token = ";";
      file-types = [];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "mir";
      name = "llvm-mir";
      roots = [];
      scope = "source.llvm_mir";
    }
    {
      comment-token = "#";
      file-types = ["mir"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      name = "llvm-mir-yaml";
      roots = [];
      scope = "source.yaml";
    }
    {
      comment-token = "//";
      file-types = ["td"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "tablegen";
      name = "tablegen";
      roots = [];
      scope = "source.tablegen";
    }
    {
      file-types = ["md" "markdown"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "md|markdown";
      language-server = {
        args = ["server"];
        command = "marksman";
      };
      name = "markdown";
      roots = [".marksman.toml"];
      scope = "source.md";
    }
    {
      file-types = [];
      grammar = "markdown_inline";
      injection-regex = "markdown\\.inline";
      name = "markdown.inline";
      roots = [];
      scope = "source.markdown.inline";
    }
    {
      auto-format = true;
      comment-token = "//";
      file-types = ["dart"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      language-server = {
        args = ["language-server" "--client-id=helix"];
        command = "dart";
      };
      name = "dart";
      roots = ["pubspec.yaml"];
      scope = "source.dart";
    }
    {
      comment-token = "//";
      file-types = ["scala" "sbt"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      language-server = {command = "metals";};
      name = "scala";
      roots = ["build.sbt" "pom.xml"];
      scope = "source.scala";
    }
    {
      comment-token = "#";
      file-types = ["Dockerfile" "dockerfile"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "docker|dockerfile";
      language-server = {
        args = ["--stdio"];
        command = "docker-langserver";
      };
      name = "dockerfile";
      roots = ["Dockerfile"];
      scope = "source.dockerfile";
    }
    {
      comment-token = "#";
      file-types = ["COMMIT_EDITMSG"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      max-line-length = 72;
      name = "git-commit";
      roots = [];
      rulers = [50 72];
      scope = "git.commitmsg";
    }
    {
      comment-token = "#";
      file-types = ["diff"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "diff";
      name = "diff";
      roots = [];
      scope = "source.diff";
    }
    {
      comment-token = "#";
      file-types = ["git-rebase-todo"];
      indent = {
        tab-width = 2;
        unit = " ";
      };
      injection-regex = "git-rebase";
      name = "git-rebase";
      roots = [];
      scope = "source.gitrebase";
    }
    {
      file-types = ["regex"];
      injection-regex = "regex";
      name = "regex";
      roots = [];
      scope = "source.regex";
    }
    {
      comment-token = "#";
      file-types = [".gitmodules" ".gitconfig"];
      indent = {
        tab-width = 4;
        unit = "\t";
      };
      injection-regex = "git-config";
      name = "git-config";
      roots = [];
      scope = "source.gitconfig";
    }
    {
      comment-token = "#";
      file-types = [".gitattributes"];
      grammar = "gitattributes";
      injection-regex = "git-attributes";
      name = "git-attributes";
      roots = [];
      scope = "source.gitattributes";
    }
    {
      comment-token = "#";
      file-types = [".gitignore" ".gitignore_global"];
      grammar = "gitignore";
      injection-regex = "git-ignore";
      name = "git-ignore";
      roots = [];
      scope = "source.gitignore";
    }
    {
      file-types = ["gql" "graphql"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "graphql";
      name = "graphql";
      roots = [];
      scope = "source.graphql";
    }
    {
      auto-format = true;
      comment-token = "--";
      file-types = ["elm"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "elm";
      language-server = {command = "elm-language-server";};
      name = "elm";
      roots = ["elm.json"];
      scope = "source.elm";
    }
    {
      file-types = ["iex"];
      injection-regex = "iex";
      name = "iex";
      roots = [];
      scope = "source.iex";
    }
    {
      auto-format = true;
      comment-token = "//";
      file-types = ["res"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "rescript";
      language-server = {
        args = ["--stdio"];
        command = "rescript-language-server";
      };
      name = "rescript";
      roots = ["bsconfig.json"];
      scope = "source.rescript";
    }
    {
      auto-pairs = {
        "\"" = "\"";
        "'" = "'";
        "(" = ")";
        "[" = "]";
        "`" = "'";
        "{" = "}";
      };
      comment-token = "%%";
      file-types = ["erl" "hrl" "app" "rebar.config" "rebar.lock"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "erl(ang)?";
      language-server = {command = "erlang_ls";};
      name = "erlang";
      roots = ["rebar.config"];
      scope = "source.erlang";
    }
    {
      comment-token = "//";
      file-types = ["kt" "kts"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      language-server = {command = "kotlin-language-server";};
      name = "kotlin";
      roots = ["settings.gradle" "settings.gradle.kts"];
      scope = "source.kotlin";
    }
    {
      auto-format = true;
      comment-token = "#";
      file-types = ["hcl" "tf" "nomad"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "(hcl|tf|nomad)";
      language-server = {
        args = ["serve"];
        command = "terraform-ls";
        language-id = "terraform";
      };
      name = "hcl";
      roots = [];
      scope = "source.hcl";
    }
    {
      auto-format = true;
      comment-token = "#";
      file-types = ["tfvars"];
      grammar = "hcl";
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      language-server = {
        args = ["serve"];
        command = "terraform-ls";
        language-id = "terraform-vars";
      };
      name = "tfvars";
      roots = [];
      scope = "source.tfvars";
    }
    {
      file-types = ["org"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "org";
      name = "org";
      roots = [];
      scope = "source.org";
    }
    {
      comment-token = "//";
      file-types = ["sol"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "(sol|solidity)";
      language-server = {
        args = ["--lsp"];
        command = "solc";
      };
      name = "solidity";
      roots = [];
      scope = "source.sol";
    }
    {
      comment-token = "//";
      file-types = ["gleam"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "gleam";
      language-server = {
        args = ["lsp"];
        command = "gleam";
      };
      name = "gleam";
      roots = ["gleam.toml"];
      scope = "source.gleam";
    }
    {
      comment-token = "//";
      file-types = ["ron"];
      grammar = "rust";
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "ron";
      name = "ron";
      roots = [];
      scope = "source.ron";
    }
    {
      comment-token = "#";
      file-types = ["r" "R"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "(r|R)";
      language-server = {
        args = ["--slave" "-e" "languageserver::run()"];
        command = "R";
      };
      name = "r";
      roots = [];
      scope = "source.r";
      shebangs = ["r" "R"];
    }
    {
      file-types = ["rmd" "Rmd"];
      grammar = "markdown";
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "(r|R)md";
      language-server = {
        args = ["--slave" "-e" "languageserver::run()"];
        command = "R";
      };
      name = "rmarkdown";
      roots = [];
      scope = "source.rmd";
    }
    {
      auto-format = true;
      comment-token = "//";
      file-types = ["swift"];
      injection-regex = "swift";
      language-server = {command = "sourcekit-lsp";};
      name = "swift";
      roots = ["Package.swift"];
      scope = "source.swift";
    }
    {
      file-types = ["erb"];
      grammar = "embedded-template";
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "erb";
      name = "erb";
      roots = [];
      scope = "text.html.erb";
    }
    {
      file-types = ["ejs"];
      grammar = "embedded-template";
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "ejs";
      name = "ejs";
      roots = [];
      scope = "text.html.ejs";
    }
    {
      file-types = ["eex"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "eex";
      name = "eex";
      roots = [];
      scope = "source.eex";
    }
    {
      file-types = ["heex"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "heex";
      name = "heex";
      roots = [];
      scope = "source.heex";
    }
    {
      comment-token = "--";
      file-types = ["sql"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "sql";
      name = "sql";
      roots = [];
      scope = "source.sql";
    }
    {
      auto-format = true;
      comment-token = "#";
      file-types = ["gd"];
      indent = {
        tab-width = 4;
        unit = "\t";
      };
      injection-regex = "gdscript";
      name = "gdscript";
      roots = ["project.godot"];
      scope = "source.gdscript";
      shebangs = [];
    }
    {
      auto-format = false;
      comment-token = "#";
      file-types = ["tscn" "tres"];
      indent = {
        tab-width = 4;
        unit = "\t";
      };
      injection-regex = "godot";
      name = "godot-resource";
      roots = ["project.godot"];
      scope = "source.tscn";
      shebangs = [];
    }
    {
      comment-token = "#";
      file-types = ["nu"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "nu";
      name = "nu";
      roots = [];
      scope = "source.nu";
    }
    {
      comment-token = "//";
      file-types = ["vala" "vapi"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "vala";
      language-server = {command = "vala-language-server";};
      name = "vala";
      roots = [];
      scope = "source.vala";
    }
    {
      comment-token = "//";
      file-types = ["ha"];
      indent = {
        tab-width = 8;
        unit = "\t";
      };
      injection-regex = "hare";
      name = "hare";
      roots = [];
      scope = "source.hare";
    }
    {
      comment-token = "//";
      file-types = ["dts" "dtsi"];
      indent = {
        tab-width = 4;
        unit = "\t";
      };
      injection-regex = "(dtsi?|devicetree|fdt)";
      name = "devicetree";
      roots = [];
      scope = "source.devicetree";
    }
    {
      comment-token = "#";
      file-types = ["cairo"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "cairo";
      name = "cairo";
      roots = [];
      scope = "source.cairo";
    }
    {
      auto-format = true;
      comment-token = "//";
      file-types = ["cpon" "cp"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "cpon";
      name = "cpon";
      roots = [];
      scope = "scope.cpon";
    }
    {
      auto-format = false;
      comment-token = "//";
      file-types = ["odin"];
      indent = {
        tab-width = 4;
        unit = "\t";
      };
      language-server = {
        args = [];
        command = "ols";
      };
      name = "odin";
      roots = ["ols.json"];
      scope = "source.odin";
    }
    {
      comment-token = "#";
      file-types = ["meson.build"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "meson";
      name = "meson";
      roots = [];
      scope = "source.meson";
    }
    {
      file-types = [".ssh/config" "/etc/ssh/ssh_config"];
      name = "sshclientconfig";
      roots = [];
      scope = "source.sshclientconfig";
    }
    {
      comment-token = ";";
      file-types = ["ss" "rkt"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "scheme";
      name = "scheme";
      roots = [];
      scope = "source.scheme";
    }
    {
      auto-format = true;
      comment-token = "//";
      file-types = ["v" "vv"];
      indent = {
        tab-width = 4;
        unit = "\t";
      };
      language-server = {
        args = [];
        command = "vls";
      };
      name = "v";
      roots = ["v.mod"];
      scope = "source.v";
      shebangs = ["v run"];
    }
    {
      comment-token = "//";
      file-types = ["v" "vh" "sv" "svh"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "verilog";
      language-server = {
        args = [];
        command = "svlangserver";
      };
      name = "verilog";
      roots = [];
      scope = "source.verilog";
    }
    {
      file-types = ["edoc" "edoc.in"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "edoc";
      name = "edoc";
      roots = [];
      scope = "source.edoc";
    }
    {
      file-types = ["jsdoc"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "jsdoc";
      name = "jsdoc";
      roots = [];
      scope = "source.jsdoc";
    }
    {
      comment-token = "//";
      file-types = ["scad"];
      indent = {
        tab-width = 2;
        unit = "\t";
      };
      injection-regex = "openscad";
      language-server = {
        args = ["--stdio"];
        command = "openscad-lsp";
      };
      name = "openscad";
      roots = [];
      scope = "source.openscad";
    }
    {
      comment-token = "//";
      file-types = ["prisma"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "prisma";
      language-server = {
        args = ["--stdio"];
        command = "prisma-language-server";
      };
      name = "prisma";
      roots = ["package.json"];
      scope = "source.prisma";
    }
    {
      comment-token = ";";
      file-types = ["clj" "cljs" "cljc" "clje" "cljr" "cljx" "edn" "boot"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "(clojure|clj|edn|boot)";
      language-server = {command = "clojure-lsp";};
      name = "clojure";
      roots = ["project.clj" "build.boot" "deps.edn" "shadow-cljs.edn"];
      scope = "source.clojure";
    }
    {
      comment-token = "#";
      file-types = ["bzl" "bazel" "BUILD"];
      grammar = "python";
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "(starlark|bzl|bazel)";
      name = "starlark";
      roots = [];
      scope = "source.starlark";
    }
    {
      comment-token = "#";
      file-types = ["elv"];
      grammar = "elvish";
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      language-server = {
        args = ["-lsp"];
        command = "elvish";
      };
      name = "elvish";
      roots = [];
      scope = "source.elvish";
    }
    {
      comment-token = "--";
      file-types = ["idr"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "idr";
      language-server = {command = "idris2-lsp";};
      name = "idris";
      roots = [];
      scope = "source.idr";
      shebangs = [];
    }
    {
      comment-token = "!";
      file-types = ["f" "for" "f90" "f95" "f03"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "fortran";
      language-server = {
        args = ["--lowercase_intrinsics"];
        command = "fortls";
      };
      name = "fortran";
      roots = ["fpm.toml"];
      scope = "source.fortran";
    }
    {
      comment-token = "//";
      file-types = ["ungram" "ungrammar"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "ungrammar";
      name = "ungrammar";
      roots = [];
      scope = "source.ungrammar";
    }
    {
      comment-token = "//";
      file-types = ["dot"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "dot";
      language-server = {
        args = ["--stdio"];
        command = "dot-language-server";
      };
      name = "dot";
      roots = [];
      scope = "source.dot";
    }
    {
      auto-format = true;
      comment-token = "//";
      file-types = ["cue"];
      indent = {
        tab-width = 4;
        unit = "\t";
      };
      injection-regex = "cue";
      language-server = {command = "cuelsp";};
      name = "cue";
      roots = ["cue.mod"];
      scope = "source.cue";
    }
    {
      comment-token = "//";
      file-types = ["slint"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "slint";
      language-server = {
        args = [];
        command = "slint-lsp";
      };
      name = "slint";
      roots = [];
      scope = "source.slint";
    }
    {
      comment-token = "#";
      file-types = ["task"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "task";
      name = "task";
      roots = [];
      scope = "source.task";
    }
    {
      file-types = ["xit"];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      injection-regex = "xit";
      name = "xit";
      roots = [];
      scope = "source.xit";
    }
    {
      comment-token = "#";
      file-types = ["esdl"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "esdl";
      name = "esdl";
      roots = ["edgedb.toml"];
      scope = "source.esdl";
    }
    {
      comment-token = "//";
      file-types = ["pas" "pp" "inc" "lpr" "lfm"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "pascal";
      language-server = {
        args = [];
        command = "pasls";
      };
      name = "pascal";
      roots = [];
      scope = "source.pascal";
    }
    {
      comment-token = "(*";
      file-types = ["sml"];
      injection-regex = "sml";
      name = "sml";
      roots = [];
      scope = "source.sml";
    }
    {
      comment-token = "//";
      file-types = ["libsonnet" "jsonnet"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      language-server = {
        args = ["-t" "--lint"];
        command = "jsonnet-language-server";
      };
      name = "jsonnet";
      roots = ["jsonnetfile.json"];
      scope = "source.jsonnet";
    }
    {
      file-types = ["astro"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "astro";
      name = "astro";
      roots = [];
      scope = "source.astro";
    }
    {
      comment-token = ";";
      file-types = ["bass"];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      injection-regex = "bass";
      language-server = {
        args = ["--lsp"];
        command = "bass";
      };
      name = "bass";
      roots = [];
      scope = "source.bass";
    }
  ];
}
