{
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];
  boot.supportedFilesystems = ["zfs"];
  nixpkgs.localSystem = {
    gcc.arch = "skylake";
    gcc.tune = "skylake";
    system = "x86_64-linux";
  };
}
