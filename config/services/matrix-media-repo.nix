{ config, pkgs, lib, ... }:
let
  matrix-media-repo = pkgs.callPackage ../../packages/matrix/matrix-media-repo.nix { };
  config-yml = pkgs.writeText "matrix-media-repo.yaml" (lib.generators.toYAML { } {
    repo = {
      bindAddress = "127.0.0.1";
      port = 8008;
    };
    database.postgres = "postgresql://matrix-media-repo@localhost/matrix-media-repo";
    homeservers = [{
      name = "chir.rs";
      csApi = "https://matrix.chir.rs";
    }];
    admins = [ "@lotte:chir.rs" ];
    datastores = [{
      type = "s3";
      enabled = true;
      forKinds = [ "all" ];
      opts = {
        tempPath = "/tmp/mediarepo_s3_upload";
        endpoint = "s3.us-west-000.backblazeb2.com";
        accessKeyId = "#ACCESS_KEY_ID#";
        accessSecret = "#SECRET_ACCESS_KEY";
        ssl = true;
        bucketName = "matrix-chir-rs";
        region = "us-west-000";
      };
    }];
  });
in
{
  systemd.services.matrix-media-repo = {
    description = "Matrix Media Repo";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [ matrix-media-repo ];
    preStart = ''
      akid=$(cat ${config.sops.secrets."services/matrix-media-repo/access-key-id".path})
      sak=$(cat ${config.sops.secrets."services/matrix-media-repo/access-key-id".path})
      cat ${config-yml} > /var/lib/matrix-media-repo/config.yml
      sed -i "s|#ACCESS_KEY_ID#|$akid|g' /var/lib/matrix-media-repo/config.yml
      sed -i "s|#SECRET_ACCESS_KEY#|$sak|g' /var/lib/matrix-media-repo/config.yml
    '';
    serviceConfig = {
      Type = "simple";
      User = "matrix-media-repo";
      Group = "matrix-media-repo";
      Restart = "always";
      ExecStart = "${matrix-media-repo}/bin/media_repo -config /var/lib/matrix-media-repo/config.yml";
    };
  };
  sops.secrets."services/matrix-media-repo/access-key-id".owner = "matrix-media-repo";
  sops.secrets."services/matrix-media-repo/secret-access-key".owner = "matrix-media-repo";
  users.users.matrix-media-repo = {
    description = "Matrix Media Repository";
    home = "/var/lib/matrix-media-repo";
    useDefaultShell = true;
    group = "matrix-media-repo";
    isSystemUser = true;
  };
  users.groups.matrix-media-repo = { };
  systemd.tmpfiles.rules = [
    "d '/var/lib/matrix-media-repo' 0750 matrix-media-repo matrix-media-repo - -"
  ];
}
