{
  pkgs,
  config,
  ...
}:
{
  programs.neovim = {
    plugins =
      with pkgs.vimPlugins;
      [
        (nvim-treesitter.withPlugins (p: [ ]))
        (pkgs.vimUtils.buildVimPlugin {
          name = "vim-highlighturl";
          src = pkgs.fetchFromGitHub {
            owner = "itchyny";
            repo = "vim-highlighturl";
            rev = "012fee983e03913db6ba6393307eac434999b896";
            sha256 = "18d72sgk44fwc91ziy54qr7vpzrs7qdlkwzlpvm9yr1d4k6329pc";
          };
        })
        asyncrun-vim
        bufferline-nvim
        catppuccin-nvim
        cmp-ai
        cmp-buffer
        cmp-emoji
        cmp-nvim-lsp
        cmp-omni
        cmp-path
        committia-vim
        dashboard-nvim
        delimitMate
        dressing-nvim
        fidget-nvim
        firenvim
        git-conflict-nvim
        gitlinker-nvim
        gitsigns-nvim
        headlines-nvim
        hop-nvim
        indent-blankline-nvim
        lazy-nvim
        (LeaderF.overrideAttrs (super: {
          buildInputs = [
            pkgs.python3
            pkgs.python3Packages.setuptools
          ];
        }))
        lspkind-nvim
        lualine-nvim
        neoformat
        nvim-bqf
        nvim-cmp
        nvim-gdb
        nvim-hlslens
        nvim-lspconfig
        nvim-notify
        nvim-tree-lua
        nvim-web-devicons
        open-browser-vim
        plenary-nvim
        tabular
        targets-vim
        telescope-nvim
        telescope-symbols-nvim
        unicode-vim
        vim-auto-save
        vim-commentary
        vim-eunuch
        vim-flog
        vim-fugitive
        vim-indent-object
        vim-markdown
        vim-matchup
        vim-mundo
        vim-obsession
        vim-oscyank
        vim-repeat
        vim-sandwich
        vim-scriptease
        vim-swap
        vim-toml
        vimtex
        vista-vim
        which-key-nvim
        whitespace-nvim
        wilder-nvim
        yanky-nvim
        zen-mode-nvim
      ]
      ++ (
        if pkgs.targetPlatform.system != "riscv64-linux" then
          [
            diffview-nvim
            vim-grammarous
          ]
        else
          [ ]
      );
  };
  xdg.configFile."nvim/lua/config/lazy-nvim.lua".text = ''
    local utils = require('utils')
    -- check if firenvim is active
    local firenvim_not_active = function()
      return not vim.g.started_by_firenvim
    end
    require("lazy").setup({
      {
        "hrsh7th/nvim-cmp",
        -- event = 'InsertEnter',
        event = "VeryLazy",
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          "onsails/lspkind.nvim",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-omni",
          "hrsh7th/cmp-emoji",
          "tzachar/cmp-ai"
        },
        config = function()
          require("config.nvim-cmp")
        end,
      },
      {
        "tzachar/cmp-ai",
        event = "VeryLazy",
        dependencies = {'nvim-lua/plenary.nvim'},
        config = function()
          require("config.cmp-ai")
        end,
      },
      {
        "neovim/nvim-lspconfig",
        event = { "BufRead", "BufNewFile" },
        config = function()
          require("config.lsp")
        end,
      },
      {
        "nvim-treesitter/nvim-treesitter",
        config = function()
          require("config.treesitter")
        end,
      },
      { "machakann/vim-swap", event = "VeryLazy" },
      -- Super fast buffer jump
      {
        "smoka7/hop.nvim",
        event = "VeryLazy",
        config = function()
          require("config.nvim_hop")
        end,
      },
      -- Show match number and index for searching
      {
        "kevinhwang91/nvim-hlslens",
        branch = "main",
        keys = { "*", "#", "n", "N" },
        config = function()
          require("config.hlslens")
        end,
      },
      {
        "Yggdroot/LeaderF",
        cmd = "Leaderf",
      },
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
          "nvim-telescope/telescope-symbols.nvim",
        },
      },
      {
        "lukas-reineke/headlines.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true, -- or `opts = {}`
      },
      { "catppuccin/nvim", name = "catppuccin", lazy = true },
      { "nvim-tree/nvim-web-devicons", event = "VeryLazy" },
      {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        cond = firenvim_not_active,
        config = function()
          require("config.statusline")
        end,
      },
      {
        "akinsho/bufferline.nvim",
        event = { "BufEnter" },
        cond = firenvim_not_active,
        config = function()
          require("config.bufferline")
        end,
      },
      {
        "nvimdev/dashboard-nvim",
        cond = firenvim_not_active,
        config = function()
          require("config.dashboard-nvim")
        end,
      },
      {
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        main = 'ibl',
        config = function()
          require("config.indent-blankline")
        end,
      },
      { "itchyny/vimplugin-vim-highlighturl", event = "VeryLazy" },
      {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
          require("config.nvim-notify")
        end,
      },
      {
        "tyru/open-browser.vim",
        event = "VeryLazy",
      },
      {
        "liuchengxu/vista.vim",
        enabled = function()
          if utils.executable("ctags") then
            return true
          else
            return false
          end
        end,
        cmd = "Vista",
      },
      -- Automatic insertion and deletion of a pair of characters
      { "Raimondi/delimitMate", event = "InsertEnter" },
      -- Comment plugin
      { "tpope/vim-commentary", event = "VeryLazy" },
      -- Autosave files on certain events
      { "907th/vim-auto-save", event = "InsertEnter" },
      -- Show undo history visually
      { "simnalamburt/vim-mundo", cmd = { "MundoToggle", "MundoShow" } },
      -- better UI for some nvim actions
      { "stevearc/dressing.nvim" },
      -- Manage your yank history
      {
        "gbprod/yanky.nvim",
        cmd = { "YankyRingHistory" },
        config = function()
          require("config.yanky")
        end,
      },
      -- Handy unix command inside Vim (Rename, Move etc.)
      { "tpope/vim-eunuch", cmd = { "Rename", "Delete" } },
      -- Repeat vim motions
      { "tpope/vim-repeat", event = "VeryLazy" },
      -- Auto format tools
      { "sbdchd/neoformat", cmd = { "Neoformat" } },
      -- Git command inside vim
      {
        "tpope/vim-fugitive",
        event = "User InGitRepo",
        config = function()
          require("config.fugitive")
        end,
      },
      -- Better git log display
      { "rbong/vim-flog", cmd = { "Flog" } },
      { "akinsho/git-conflict.nvim", version = "*", config = true },
      {
        "ruifm/gitlinker.nvim",
        event = "User InGitRepo",
        config = function()
          require("config.git-linker")
        end,
      },
      -- Show git change (change, delete, add) signs in vim sign column
      {
        "lewis6991/gitsigns.nvim",
        config = function()
          require("config.gitsigns")
        end,
      },
      -- Better git commit experience
      { "rhysd/committia.vim", lazy = true },
      ${
        if pkgs.targetPlatform.system != "riscv64-linux" then
          ''
            {
                    "sindrets/diffview.nvim"
                  },''
        else
          ""
      }
      {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        config = function()
          require("config.bqf")
        end,
      },
      -- Another markdown plugin
      -- { "preservim/vim-markdown", ft = { "markdown" } },
      -- Vim tabular plugin for manipulate tabular, required by markdown plugins
      -- { "godlygeek/tabular", cmd = { "Tabularize" } },
      -- Markdown previewing (only for Mac and Windows)
      --{
      --  "iamcco/markdown-preview.nvim",
      --  ft = { "markdown" },
      --},
      {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        config = function()
          require("config.zen-mode")
        end,
      },
      ${
        if pkgs.targetPlatform.system != "riscv64-linux" then
          ''
            {
                    "rhysd/vim-grammarous",
                    ft = { "markdown" },
                  },''
        else
          ""
      }
      { "chrisbra/unicode.vim", event = "VeryLazy" },
      -- Additional powerful text object for vim, this plugin should be studied
      -- carefully to use its full power
      { "wellle/targets.vim", event = "VeryLazy" },
      -- Plugin to manipulate character pairs quickly
      { "machakann/vim-sandwich", event = "VeryLazy" },
      -- Add indent object for vim (useful for languages like Python)
      { "michaeljsmith/vim-indent-object", event = "VeryLazy" },
      -- Only use these plugin on Windows and Mac and when LaTeX is installed
      {
        "lervag/vimtex",
        enabled = function()
          if utils.executable("latex") then
            return true
          end
          return false
        end,
        ft = { "tex" },
      },
      -- Modern matchit implementation
      { "andymass/vim-matchup", event = "BufRead" },
      { "tpope/vim-scriptease", cmd = { "Scriptnames", "Message", "Verbose" } },
      -- Asynchronous command execution
      { "skywind3000/asyncrun.vim", lazy = true, cmd = { "AsyncRun" } },
      { "cespare/vim-toml", ft = { "toml" }, branch = "main" },
      -- Edit text area in browser using nvim
      {
        "glacambre/firenvim",
        build = function()
          vim.fn["firenvim#install"](0)
        end,
        lazy = true,
      },
      -- Debugger plugin
      {
        "sakhnik/nvim-gdb",
        lazy = true,
      },
      -- Session management plugin
      { "tpope/vim-obsession", cmd = "Obsession" },
      {
        "ojroques/vim-oscyank",
        enabled = function()
          if vim.g.is_linux then
            return true
          end
          return false
        end,
        cmd = { "OSCYank", "OSCYankReg" },
      },
      -- The missing auto-completion for cmdline!
      {
        "gelguy/wilder.nvim",
        build = ":UpdateRemotePlugins",
      },
      -- showing keybindings
      {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
          require("config.which-key")
        end,
      },
      -- show and trim trailing whitespaces
      { "jdhao/whitespace.nvim", event = "VeryLazy" },
      -- file explorer
      {
        "nvim-tree/nvim-tree.lua",
        keys = { "<space>s" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
          require("config.nvim-tree")
        end,
      },
      {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        tag = "legacy",
        config = function()
          require("config.fidget-nvim")
        end,
      },
    }, {
      performance = {
        reset_packpath = false,
        rtp = {
            reset = false,
        }
      },
      dev = {
        path = "${pkgs.vimUtils.packDir config.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start",
        patterns = {
          "907th",
          "akinsho",
          "andymass",
          "catppuccin",
          "cespare",
          "chrisbra",
          "folke",
          "gbprod",
          "gelguy",
          "glacambre",
          "godlygeek",
          "honza",
          "hrsh7th",
          "iamcco",
          "itchyny",
          "j-hui",
          "jdhao",
          "kevinhwang91",
          "lervag",
          "lewis6991",
          "liuchengxu",
          "lukas-reineke",
          "machakann",
          "michaeljsmith",
          "neovim",
          "nvim-lua",
          "nvim-lualine",
          "nvim-telescope",
          "nvim-tree",
          "nvim-treesitter",
          "nvimdev",
          "ojroques",
          "onsails",
          "preservim",
          "quangnguyen30192",
          "Raimondi",
          "rbong",
          "rcarriga",
          "rhysd",
          "ruifm",
          "sakhnik",
          "sbdchd",
          "simnalamburt",
          "sindrets",
          "SirVer",
          "skywind3000",
          "smoka7",
          "stevearc",
          "tpope",
          "tyru",
          "tzachar",
          "wellle",
          "Yggdroot",
        },
      },
      install = {
        missing = false,
      },
      ui = {
        border = "rounded",
        title = "Plugin Manager",
        title_pos = "center",
      },
    })
  '';
}
