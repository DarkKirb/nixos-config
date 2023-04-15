_: {
  vim.keybindings.which-key-nvim = true;
  plugin.setup.which-key = {
    plugins = {
      marks = true;
      registers = true;
      spelling = {
        enabled = true;
        suggestions = 9;
      };
      presets = {
        operators = true;
        motions = true;
        text_objects = true;
        windows = true;
        nav = true;
        z = true;
        g = true;
      };
    };
    operators.gc = "Comments";
    icons = {
      breadcrumbs = "»";
      separator = "➜";
      group = "+";
    };
    window = {
      border = "none";
      position = "bottom";
      margin = [0 0 0 0];
      padding = [1 0 1 0];
    };
    layout = {
      height = {
        min = 1;
        max = 25;
      };
      width = {
        min = 20;
        max = 50;
      };
      spacing = 1;
      align = "center";
    };
    ignore_missing = false;
    hidden = ["<silent>" "<cmd>" "<Cmd>" "<CR>" "call" "lua" "^:" "^ "];
    show_help = true;
    triggers = "auto";

    triggers_blacklist = {
      n = ["o" "O"];
    };
  };
}
