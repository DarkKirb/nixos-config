{pkgs, ...}: {
  vim.g = {
    copilot_filetypes = {
      "*" = true;
    };
    copilot_node_command = "${pkgs.nodejs-16_x}/bin/node";
  };
  output.plugins = with pkgs.vimPlugins; [copilot-vim];
}
