{
  config,
  pkgs,
  ...
}: 
let 
  firefox-wrapped = config.programs.firefox.package;
  firefox = firefox-wrapped.unwrapped;
  nss = pkgs.lib.lists.findFirst (x: x.pname == "nss") null firefox.buildInputs;
in {
  home.packages = with pkgs; [
    (discord.override { inherit nss; })
    tdesktop
    element-desktop
  ];
}
