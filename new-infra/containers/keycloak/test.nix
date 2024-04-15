{pkgs ? import <nixpkgs> {}, ...}:
pkgs.testers.runNixOSTest {
  name = "keycloak";

  nodes.keycloak = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      ./default.nix
      ../../default.nix
    ];
    system.stateVersion = "23.11";
  };
  testScript = ''
    keycloak.wait_for_unit("container@keycloak.service")
    keycloak.succeed("sleep 60")
    keycloak.succeed("nixos-container run keycloak -- curl -v 'http://localhost:8080/health'")
  '';
}
