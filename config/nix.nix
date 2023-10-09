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
        "chir-rs:/iTDNHmQw1HklELHTBAVDFVAFaJ3ACGu3eezVUtplKc="
        "riscv:TZX1ReuoIGt7QiSQups+92ym8nKJUSV0O2NkS4HAqH8="
        "cache.ztier.link-1:3P5j2ZB9dNgFFFVkCQWT3mh0E+S3rIWtZvoql64UaXM="
      ];
      auto-optimise-store = true;
    };
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
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
            ];
            maxJobs = 4;
            speedFactor = 1;
            supportedFeatures = ["nixos-test" "benchmark" "ca-derivations" "gccarch-armv8-a" "gccarch-armv8.1-a" "gccarch-armv8.2-a" "big-parallel"];
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

      builds=$(${pkgs.curl}/bin/curl -H 'accept: application/json' https://hydra.int.chir.rs/jobset/flakes/nixos-config/evals | ${pkgs.jq}/bin/jq -r '.evals[0].builds[]')

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
  systemd.timers.nixos-upgrade = {
    timerConfig = {
      OnBootSec = 300;
      RandomizedDelaySec = 3600;
      OnUnitActiveSec = 3600;
    };
    requires = ["nixos-upgrade.service"];
    wantedBy = ["multi-user.target"];
  };
  systemd.sockets.nixos-upgrade = {
    socketConfig = {
      Service = "nixos-upgrade.service";
      BindIPv6Only = true;
      ListenDatagram = "[::]:15553";
    };
  };
}
