{
  config,
  pkgs,
  lib,
  ...
}: 
let 
  firefox-wrapped = config.programs.firefox.package;
  firefox = firefox-wrapped.unwrapped;
  nss = pkgs.lib.lists.findFirst (x: x.pname or x.name == "nss") null firefox.buildInputs;
in {
  home.packages = with pkgs; [
    (discord.override { inherit nss; })
    tdesktop
    element-desktop
    nheko
  ];
  home.activation.betterDiscord = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${pkgs.betterdiscordctl}/bin/betterdiscordctl install $VERBOSE_ARG || true
  '';
}
