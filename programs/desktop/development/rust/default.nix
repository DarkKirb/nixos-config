{
  pkgs,
  config,
  systemConfig,
  ...
}:
{
  home.packages = with pkgs; [
    (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default))
    cargo-mommy
  ];
  home.shellAliases = {
    cargo = "${pkgs.cargo-mommy}/bin/cargo-mommy";
  };
  home.sessionVariables =
    (
      if systemConfig.isNSFW then
        {
          CARGO_MOMMYS_MOODS = "chill/thirsty/yikes";
          CARGO_MOMMYS_LITTLE = "racc/plush";
          CARGO_MOMMYS_PARTS = "shit/pee";
          CARGO_MOMMYS_FUCKING = "pet/toy/toilet/shitslut/septic tank";
        }
      else
        {
          CARGO_MOMMYS_MOODS = "chill";
          CARGO_MOMMYS_LITTLE = "racc/plush";
        }
    )
    // {
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
    };
  systemd.user.tmpfiles.rules = [
    "d ${config.xdg.cacheHome}/cargo - - - - -"
    "d ${config.xdg.cacheHome}/cargo/git - - - - -"
    "d ${config.xdg.cacheHome}/cargo/registry - - - - -"
    "L ${config.xdg.dataHome}/cargo/git - - - - ${config.xdg.cacheHome}/cargo/git"
    "L ${config.xdg.dataHome}/cargo/registry - - - - ${config.xdg.cacheHome}/cargo/registry"
  ];
  xdg.dataFile."cargo/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
    build.target-dir = "${config.xdg.cacheHome}/cargo/target";
    profile.release = {
      lto = true;
      codegen-units = 1;
    };
  };
}
