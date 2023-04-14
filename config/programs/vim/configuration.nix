# Taken from https://github.com/syberant/nix-config/tree/master/configuration/home-manager/modules/neovim
desktop: {
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  getNixFiles = dir: let
    recu = n: k:
      if k == "directory"
      then getNixFiles "${dir}/${n}"
      else if hasSuffix "nix" n
      then ["${dir}/${n}"]
      else [];
  in
    flatten (mapAttrsToList recu (readDir dir));
in {
  imports =
    getNixFiles ./modules
    ++ (
      if desktop
      then [./desktop.nix]
      else []
    );

  config = {
    output.path.style = "impure";
    output.makeWrapper = "--set LUA_PATH '${./modules/lua}/?.lua;;'";
    isDesktop = lib.mkDefault false;
    extraLua = builtins.concatStringsSep "\n" (map (f: "require('${f}')") config.extraLuaModules);
    output.extraConfig = ''
      lua << EOF_991fbac8c1efc440
      ${config.extraLua}
      EOF_991fbac8c1efc440
    '';

    vim.keybindings.leader = " ";

    vim.opt = {
      # undo/backup directories
      undofile = true;
      backup = true;
      # tab settings
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      matchpairs = "(:),{:},[:],<:>,「:」,『:』,【:】,“:”,‘:’,《:》,«:»,‹:›";
      number = true;
      relativenumber = true;
      ignorecase = true;
      smartcase = true;
      fileencoding = "utf-8";

      linebreak = true;
      showbreak = "↪";
      wildmode = "list:longest";
      scrolloff = 3;
      mouse = "a";
      mousemodel = "popup";
      list = true;
      listchars = "tab:▸ ,extends:❯,precedes:❮,nbsp:␣";
      autowrite = true;
      shortmess = "filnxtToOFcSI";
      completeopt = "menu,preview,menuone";
      pumheight = 10;
      pumblend = 10;
      winblend = 0;
      complete = "kspell,.";
      spelllang = "en";
      spellsuggest = "best,9";
      shiftround = true;
      virtualedit = "block";
      formatoptions = "tcqjmM";
      tildeop = true;
      synmaxcol = 250;
      startofline = false;
      grepprg = "rg --vimgrep --no-heading --smart-case";
      grepformat = "%f:%l:%c:%m";
      termguicolors = true;
      guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor20";
      signcolumn = "yes:1";
      diffopt = "vertical,filler,closeoff,context:3,internal,indent-heuristic,algorithm:histogram";
      wrap = false;
      ruler = true;
    };

    extraLuaModules = [
      "config.undodir"
    ];

    vim.g.isDesktop = config.isDesktop;
    vim.g.nix_system = pkgs.system;

    output.path.path = with pkgs; [ripgrep];
  };
  options.isDesktop = lib.options.mkEnableOption "desktop integration and LSP";
  options.extraLua = lib.options.mkOption {
    type = lib.types.lines;
    default = "";
    description = "Extra lua configuration to add";
  };
  options.extraLuaModules = lib.options.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Extra lua modules to require";
  };
}
