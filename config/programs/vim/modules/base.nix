{
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

    undodir = "~/.cache/nvim/undo-files";
    undofile = true;

    mouse = "a";
    clipboard = "unnamedplus";

    # Searching
    ignorecase = true;
    smartcase = true;

    # Wildmode
    wildmenu = true;
    wildignorecase = true;
    wildignore = [ "*.o" "*~" "*.out" ];
    wildmode = [ "longest" "list" "full" ];
  };

  vim.keybindings.keybindings-shortened = {
    j = { command = "gj"; };
    k = { command = "gk"; };
    "0" = { command = "g0"; };
    "$" = { command = "g$"; };
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
  '';
}