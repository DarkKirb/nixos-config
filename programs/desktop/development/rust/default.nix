{
  pkgs,
  config,
  systemConfig,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    cargo-mommy
    clang
  ];
  home.shellAliases = {
    cargo = "${lib.getExe pkgs.cargo-mommy}";
  };
  home.sessionVariables =
    (
      if systemConfig.system.isNSFW then
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
  sops.secrets.".local/share/cargo/credentials/procyos".sopsFile = ./secrets.yaml;
  sops.templates.".local/share/cargo/credentials.toml" = {
    path = "${config.xdg.dataHome}/cargo/credentials.toml";
    content = ''
      [registries.procyos]
      token = "${config.sops.placeholder.".local/share/cargo/credentials/procyos"}"
    '';
  };
}
