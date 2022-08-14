{ pkgs, lib, ... }: {
  vim.keybindings = {
    keybindings = {
      "[" = {
        b = {
          command = "<cmd>BufferLineCycleNext<CR>";
          label = "Navigate to next buffer";
          options.silent = true;
        };
      };
      "]" = {
        b = {
          command = "<cmd>BufferLineCyclePrev<CR>";
          label = "Navigate to previous buffer";
          options.silent = true;
        };
      };
      "<leader>" = {
        b = {
          d = {
            command = "<cmd>BufferLineSortByDirectory<CR>";
            label = "Sort bufferline by directory";
            options.silent = true;
          };
          e = {
            command = "<cmd>BufferLineSortByExtension<CR>";
            label = "Sort bufferline by extension";
            options.silent = true;
          };
          "$" = {
            command = "<cmd>BufferLineGoToBuffer -1<CR>";
            label = "Go to last buffer";
            options.silent = true;
          };
        } // (lib.attrsets.genAttrs ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9"] (n: {
          command = "<cmd>BufferLineGoToBuffer ${n}<CR>";
          label = "Go to buffer ${n}";
          options.silent = true;
        }));
      };
      g = {
        b = {
          command = "<cmd>BufferLinePick<CR>";
          label = "Go to buffer";
          options.silent = true;
        };
      };
    };
  };
  output.plugins = with pkgs.vimPlugins; [
    bufferline-nvim
  ];
  output.extraConfig = ''
    set termguicolors
    set tabline=
    lua << EOF
    require("bufferline").setup{
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local s = " "
        for e, n in pairs(diagnostics_dict) do
          local sym = e == "error" and " "
            or (e == "warning" and " " or "" )
          s = s .. n .. sym
        end
        return s
      end
    }
    EOF
    '';
}

