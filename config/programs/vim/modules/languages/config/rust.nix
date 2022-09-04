{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [rust-tools-nvim];
  output.config_file = ''
    lua require("rust-analyzer-config")
  '';
}
