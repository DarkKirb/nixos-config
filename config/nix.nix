{
  pkgs,
  lib,
  config,
  system,
  attic,
  ...
}: {
  imports = [
    ./workarounds
  ];
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      sandbox = true;
      trusted-users = ["@wheel" "remote-build"];
      require-sigs = true;
      builders-use-substitutes = true;
      substituters = [
        "https://attic.chir.rs/chir-rs/"
        "https://hydra.int.chir.rs"
      ];
      trusted-public-keys = [
        "nixcache:8KKuGz95Pk4UJ5W/Ni+pN+v+LDTkMMFV4yrGmAYgkDg="
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "chir-rs:rzK1Czm3RqBbZLnXYrLM6JyOhfr6Z/8lhACIPO/LNFQ="
        "riscv:TZX1ReuoIGt7QiSQups+92ym8nKJUSV0O2NkS4HAqH8="
        "cache.ztier.link-1:3P5j2ZB9dNgFFFVkCQWT3mh0E+S3rIWtZvoql64UaXM="
      ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
      builders-use-substitutes = true
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    buildMachines = with lib;
      mkMerge [
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
            supportedFeatures = ["nixos-test" "benchmark" "ca-derivations" "gccarch-armv8-a" "gccarch-armv8.1-a" "gccarch-armv8.2-a" "big-parallel"];
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
            speedFactor = 1;
            supportedFeatures = [
              "kvm"
              "nixos-test"
              "big-parallel"
              "benchmark"
              "gccarch-skylake-avx512"
              "gccarch-znver3"
              "gccarch-znver2"
              "gccarch-znver1"
              "gccarch-skylake"
              "ca-derivations"
            ];
          }
        ])
        (mkIf (config.networking.hostName != "vf2") [
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
    distributedBuilds = true;
  };
  systemd.services.nix-daemon.environment.TMPDIR = "/build";
  systemd.services.nixos-upgrade = {
    description = "NixOS Upgrade";

    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;

    serviceConfig.Type = "oneshot";

    path = with pkgs; [
      coreutils
      gnutar
      xz.bin
      gzip
      gitMinimal
      config.nix.package.out
      config.programs.ssh.package
      jq
      curl
    ];

    script = lib.mkDefault ''
      #!${pkgs.bash}/bin/bash
      set -ex
      builds=$(${pkgs.curl}/bin/curl -H 'accept: application/json' https://hydra.int.chir.rs/jobset/nixos-config/nixos-config/evals | ${pkgs.jq}/bin/jq -r '.evals[0].builds[]')
      for build in $builds; do
          doc=$(${pkgs.curl}/bin/curl -H 'accept: application/json' https://hydra.int.chir.rs/build/$build)
          jobname=$(echo $doc | ${pkgs.jq}/bin/jq -r '.job')
          if [ "$jobname" = "${config.networking.hostName}.${system}" ]; then
              drvname=$(echo $doc | ${pkgs.jq}/bin/jq -r '.drvpath')
              output=$(${pkgs.nix}/bin/nix-store -r $drvname)
              $output/bin/switch-to-configuration boot
              booted="$(${pkgs.coreutils}/bin/readlink /run/booted-system/{initrd,kernel,kernel-modules})"
              built="$(${pkgs.coreutils}/bin/readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"
              if [ "$booted" = "$built" ]; then
                  $output/bin/switch-to-configuration switch
              else
                  ${pkgs.systemd}/bin/shutdown -r +1
              fi
              exit
          fi
      done
    '';
    after = ["network-online.target"];
    wants = ["network-online.target"];
  };
  systemd.sockets.nixos-upgrade = {
    socketConfig = {
      Service = "nixos-upgrade.service";
      BindIPv6Only = true;
      ListenDatagram = "[::]:15553";
    };
  };
}
