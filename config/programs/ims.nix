{
  config,
  pkgs,
  lib,
  nixpkgs,
  ...
}: let
  x86_64-linux-pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
  firefox-wrapped = x86_64-linux-pkgs.firefox; #config.programs.firefox.package;
  firefox = firefox-wrapped.unwrapped;
  nss = pkgs.lib.lists.findFirst (x: x.pname or x.name == "nss") null firefox.buildInputs;
in {
  home.packages = with pkgs; [
    (x86_64-linux-pkgs.discord.override {inherit nss;})
    tdesktop
    element-desktop
    nheko
    cinny-desktop
  ];
  home.activation.betterDiscord = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${pkgs.betterdiscordctl}/bin/betterdiscordctl install $VERBOSE_ARG || true
  '';
}
