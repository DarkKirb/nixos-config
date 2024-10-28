{
  callPackage,
  testers,
  nixos-config,
  inputs,
}:
testers.runNixOSTest {
  name = "container-default-test";
  nodes.default = {
    config,
    pkgs,
    nixos-config,
    ...
  }: {
    imports = [
      nixos-config.nixosModules.default
    ];
    autoContainers = ["default"];
  };
  node.specialArgs = inputs;
  testScript = ''
    machine.wait_for_unit("container@default.service")
  '';
}
