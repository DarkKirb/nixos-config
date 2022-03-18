{ ... }: {
  nixpkgs.localSystem = {
    gcc.arch = "skylake";
    gcc.tune = "skylake-avx512";
    system = "x86_64-linux";
  };
}
