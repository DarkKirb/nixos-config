{ pkgs, nix-packages, config, ... }:
let static_dir = pkgs.stdenvNoCC.mkDerivation {
  name = "akkoma-static";
  src = pkgs.emptyDirectory;
  nativeBuildInputs = with pkgs; [xorg.lndir];
  akkoma_fe = nix-packages.packages.${pkgs.system}.akkoma-fe;
  dontUnpack = false;
  installPhase = ''
    mkdir -p $out/frontends/pleroma-fe/stable
    lndir $akkoma_fe $out/frontends/pleroma-fe/stable
  '';
};
akkconfig = builtins.replaceStrings ["%AKKOMA_STATIC_DIR%"] ["${static_dir}"] (builtins.readFile ./akkoma.exs);
in{
  services.pleroma = {
    enable = true;
    package = nix-packages.packages.${pkgs.system}.akkoma;
    configs = [ akkconfig ];
    user = "akkoma";
    group = "akkoma";
    secretConfigFile = config.sops.secrets."services/akkoma.exs".path;
  };
  systemd.services.pleroma.path = with pkgs; [ exiftool imagemagick ffmpeg ];
  services.postgresql.ensureDatabases = ["akkoma"];
  services.postgresql.ensureUsers = [
    {
      name = "akkoma";
      ensurePermissions = {"DATABASE akkoma" = "ALL PRIVILEGES";};
    }
  ];
  sops.secrets."services/akkoma.exs" = { owner = "akkoma"; };
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
