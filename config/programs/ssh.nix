_: {
  imports = [
    ./builders.nix
  ];
  programs.ssh = {
    controlMaster = "auto";
    controlPersist = "10m";
    enable = true;
  };
}
