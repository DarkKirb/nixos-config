{
  pkgs,
  nix-packages,
  config,
  ...
}: let
  raccoon-emoji = pkgs.fetchzip {
    url = "https://volpeon.ink/art/emojis/raccoon/raccoon.zip";
    sha256 = "b1986c87e44efcf08abaf2bb818f319e8d3dceb9f2f1a49d50e1c5bfc4434e64";
    stripRoot = false;
  };
  static_dir = pkgs.stdenvNoCC.mkDerivation {
    name = "akkoma-static";
    src = pkgs.emptyDirectory;
    nativeBuildInputs = with pkgs; [xorg.lndir];
    akkoma_fe = nix-packages.packages.${pkgs.system}.akkoma-fe;
    akkoma_admin_fe = nix-packages.packages.${pkgs.system}.akkoma-admin-fe;
    raccoon_emoji = raccoon-emoji;
    dontUnpack = false;
    installPhase = ''
      mkdir -p $out/frontends/pleroma-fe/stable
      lndir $akkoma_fe $out/frontends/pleroma-fe/stable
      mkdir -p $out/frontends/admin-fe/stable
      lndir $akkoma_admin_fe $out/frontends/admin-fe/stable
      mkdir -p $out/emoji/raccoons
      lndir $raccoon_emoji $out/emoji/raccoons
    '';
  };
  akkconfig = builtins.replaceStrings ["%AKKOMA_STATIC_DIR%"] ["${static_dir}"] (builtins.readFile ./akkoma.exs);
in {
  services.pleroma = {
    enable = true;
    package = nix-packages.packages.${pkgs.system}.akkoma;
    configs = [akkconfig];
    user = "akkoma";
    group = "akkoma";
    secretConfigFile = config.sops.secrets."services/akkoma.exs".path;
  };
  systemd.services.pleroma.path = with pkgs; [exiftool imagemagick ffmpeg];
  services.postgresql.ensureDatabases = ["akkoma"];
  services.postgresql.ensureUsers = [
    {
      name = "akkoma";
      ensurePermissions = {"DATABASE akkoma" = "ALL PRIVILEGES";};
    }
  ];
  sops.secrets."services/akkoma.exs" = {owner = "akkoma";};
  services.caddy.virtualHosts."akko.chir.rs" = {
    useACMEHost = "chir.rs";
    extraConfig = ''
      import baseConfig
      handle /media_attachments/* {
        redir https://mastodon-assets.chir.rs{uri} permanent
      }
      handle {
        reverse_proxy {
          to http://127.0.0.1:4000
        }
      }
    '';
  };
}
