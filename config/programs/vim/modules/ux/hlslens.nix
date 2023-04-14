{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [nvim-hlslens];
  plugin.setup.hlslens = {};
  vim.keybindings.keybindings = {
    n = {
      command = "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>";
      options.silent = true;
      label = "Continue search forwards";
    };
    N = {
      command = "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>";
      options.silent = true;
      label = "Continue search backwards";
    };
    "*" = {
      command = "*<Cmd>lua require('hlslens').start()<CR>";
      options.silent = true;
      label = "Next identifier";
    };
    "#" = {
      command = "#<Cmd>lua require('hlslens').start()<CR>";
      options.silent = true;
      label = "Prev identifier";
    };
    g = {
      "*" = {
        command = "g*<Cmd>lua require('hlslens').start()<CR>";
        options.silent = true;
        label = "Next identifier";
      };
      "#" = {
        command = "g#<Cmd>lua require('hlslens').start()<CR>";
        options.silent = true;
        label = "Prev identifier";
      };
    };
    "<Esc>" = {
      command = "<Cmd>noh<CR>";
      options.silent = true;
      label = "Clear highlight";
    };
  };
}
