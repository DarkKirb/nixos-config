{
  config,
  pkgs,
  ...
}: let
  firefox-wrapped = config.programs.firefox.package;
  firefox = firefox-wrapped.unwrapped;
  nss = pkgs.lib.lists.findFirst (x: (builtins.hasAttr "pname" x) && (x.pname == "nss")) null firefox.buildInputs;
in {
  home.packages = with pkgs; [
    (discord.override {
      inherit nss;
    })
    element-desktop
  ];
}
