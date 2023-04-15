{
  pkgs,
  config,
  ...
}: {
  output.plugins = with pkgs.vimPlugins; [nvim-bqf];
  plugin.setup.bqf = {
    auto_resize_height = false;
    preview.auto_preview = false;
  };
}
