{ ... }: {
  nixpkgs.localSystem = {
    gcc.arch = "znver2";
    gcc.tune = "znver2";
    system = "x86_64-linux";
  };
}
