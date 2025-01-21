{
  config,
  lib,
  ...
}:
with lib;
{
  config = mkIf (!config.isInstaller) {
    nix.distributedBuilds = true;
    nix.buildMachines = mkMerge [
      (mkIf (config.networking.hostName != "instance-20221213-1915") [
        {
          hostName = "build-aarch64";
          systems = [
            "aarch64-linux"
            "riscv32-linux"
            "riscv64-linux"
          ];
          maxJobs = 4;
          speedFactor = 1;
          supportedFeatures = [
            "nixos-test"
            "benchmark"
            "ca-derivations"
            "gccarch-armv8-a"
            "gccarch-armv8.1-a"
            "gccarch-armv8.2-a"
            "big-parallel"
          ];
        }
      ])
      (mkIf (config.networking.hostName != "nas") [
        {
          hostName = "build-nas";
          systems = [
            "i686-linux"
            "x86_64-linux"
            "armv7l-linux"
            "powerpc-linux"
            "powerpc64-linux"
            "powerpc64le-linux"
            "wasm32-wasi"
            "riscv32-linux"
            "riscv64-linux"
          ];
          maxJobs = 12;
          speedFactor = 1;
          supportedFeatures = [
            "kvm"
            "nixos-test"
            "big-parallel"
            "benchmark"
            "gccarch-znver1"
            "gccarch-skylake"
            "ca-derivations"
          ];
        }
      ])
      (mkIf (config.networking.hostName != "rainbow-resort") [
        {
          hostName = "build-rainbow-resort";
          systems = [
            "i686-linux"
            "x86_64-linux"
            "armv7l-linux"
            "powerpc-linux"
            "powerpc64-linux"
            "powerpc64le-linux"
            "wasm32-wasi"
            "riscv32-linux"
            "riscv64-linux"
          ];
          maxJobs = 16;
          speedFactor = 3;
          supportedFeatures = [
            "kvm"
            "nixos-test"
            "big-parallel"
            "benchmark"
            "gccarch-skylake-avx512"
            "gccarch-znver4"
            "gccarch-znver3"
            "gccarch-znver2"
            "gccarch-znver1"
            "gccarch-skylake"
            "ca-derivations"
          ];
        }
      ])
      (mkIf (config.networking.hostName != "not522") [
        {
          hostName = "build-riscv";
          systems = [
            "riscv32-linux"
            "riscv64-linux"
          ];
          maxJobs = 4;
          speedFactor = 2;
          supportedFeatures = [
            "nixos-test"
            "big-parallel"
            "benchmark"
            "ca-derivations"
            # There are many more combinations but i simply do not care lol
            "gccarch-rv64gc_zba_zbb"
            "gccarch-rv64gc_zba"
            "gccarch-rv64gc_zbb"
            "gccarch-rv64gc"
            "gccarch-rv32gc_zba_zbb"
            "gccarch-rv32gc_zba"
            "gccarch-rv32gc_zbb"
            "gccarch-rv32gc"
            "native-riscv"
          ];
        }
      ])
    ];
  };
}
