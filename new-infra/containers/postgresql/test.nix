{pkgs ? import <nixpkgs> {}, ...}:
pkgs.testers.runNixOSTest {
  name = "postgresql";

  nodes.postgresql = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      ./default.nix
    ];
    system.stateVersion = "23.11";
  };
  testScript = ''
    postgresql.wait_for_unit("container@postgresql.service")
    postgresql.succeed("nixos-container run postgresql -- systemctl start postgresqlBackup.service")
    postgresql.succeed("stat /persist/backup/postgresql/all.sql.zstd")
  '';
}
