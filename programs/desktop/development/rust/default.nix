{
  pkgs,
  config,
  systemConfig,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    rust-bin.stable.latest.default
    cargo-mommy
    clang
  ];
  home.shellAliases = {
    cargo = "${lib.getExe pkgs.cargo-mommy}";
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
    "d /persistent${config.xdg.cacheHome}/cargo - - - - -"
    "d /persistent${config.xdg.cacheHome}/cargo/git - - - - -"
    "d /persistent${config.xdg.cacheHome}/cargo/registry - - - - -"
    "L /persistent${config.xdg.dataHome}/cargo/git - - - - ${config.xdg.cacheHome}/cargo/git"
    "L /persistent${config.xdg.dataHome}/cargo/registry - - - - ${config.xdg.cacheHome}/cargo/registry"
  ];
  xdg.dataFile."cargo/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
    build.target-dir = "${config.xdg.cacheHome}/cargo/target";
    profile.release = {
      lto = true;
      codegen-units = 1;
    };
  };
}
