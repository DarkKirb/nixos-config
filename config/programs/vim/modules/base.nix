{pkgs, ...}: {
  vim.opt = {
    # Use 4 spaces and expand tabs
    expandtab = true;
    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;

    cursorline = true; # Highlight line of cursor
    number = true; # Line numbering
    relativenumber = true;
    numberwidth = 3;

    undofile = true;

    mouse = "a";
    clipboard = "unnamedplus";

    # Searching
    ignorecase = true;
    smartcase = true;

    # Wildmode
    wildmenu = true;
    wildignorecase = true;
    wildignore = ["*.o" "*~" "*.out"];
    wildmode = ["longest" "list" "full"];
  };

  # Clipboard command
  vim.g.clipboard = {
    name = "kitty";
    copy = {
      "+" = ["${pkgs.wl-clipboard}/bin/wl-copy"];
      "*" = ["${pkgs.wl-clipboard}/bin/wl-copy" "--primary"];
    };
    paste = {
      "+" = ["${pkgs.wl-clipboard}/bin/wl-paste"];
      "*" = ["${pkgs.wl-clipboard}/bin/wl-paste" "--primary"];
    };
  };

  vim.keybindings.keybindings-shortened = {
    j = {command = "gj";};
    k = {command = "gk";};
    "0" = {command = "g0";};
    "$" = {command = "g$";};
    "Y" = {
      command = "yy";
      mode = "n";
    };
  };

  output.config_file = ''
    " Enable 24-bit colours if available
    if has('termguicolors')
      set termguicolors
    endif
    set undodir=$HOME/.cache/nvim/undo-files
  '';
}
