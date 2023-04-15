{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [impatient-nvim];
  extraLuaModules = ["impatient"];
}
