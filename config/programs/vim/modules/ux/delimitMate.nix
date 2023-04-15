{pkgs, ...}: {
  output.plugins = with pkgs.vimPlugins; [delimitMate];
}
