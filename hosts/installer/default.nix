{modulesPath, ...}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];
  nixpkgs.localSystem = {
    gcc.arch = "skylake";
    gcc.tune = "skylake";
    system = "x86_64-linux";
  };
}
