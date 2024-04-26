# Based on https://github.com/Snektron/nixos-vf2/blob/master/pkgs/linux-vf2.nix
{
  lib,
  fetchFromGitHub,
  linuxManualConfig,
  fetchpatch,
  applyPatches,
  ...
} @ args: let
  modDirVersion = "6.4.0";
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
  linuxManualConfig ({
      inherit modDirVersion;
      version = "${modDirVersion}-vf2";

      src = applyPatches {
        src = fetchFromGitHub {
          owner = "starfive-tech";
          repo = "linux";
          inherit (source) rev sha256;
        };
        patches = [
          (fetchpatch {
            name = "axp15060-1.patch";
            url = "https://lore.kernel.org/all/20230524000012.15028-2-andre.przywara@arm.com/raw";
            hash = "sha256-kj4vQaT4CV29EHv8MtuTgM/semIPDdv2dmveo/X27vU=";
          })
          (fetchpatch {
            name = "axp15060-2.patch";
            url = "https://lore.kernel.org/all/20230524000012.15028-3-andre.przywara@arm.com/raw";
            hash = "sha256-QCPQyKqoapMtqEDB9QgAuXA7n8e1OtG+YlIgeSQBxXM=";
          })
          (fetchpatch {
            name = "axp15060-3.patch";
            url = "https://lore.kernel.org/all/20230524000012.15028-4-andre.przywara@arm.com/raw";
            hash = "sha256-SpKDm4PXR6qs7kX5SGVpFF/EPBijMhX1NsFUHrlCynM=";
          })
        ];
      };

      configfile = ./vf2.config;

      extraMeta = {
        branch = "JH7110_VisionFive2_upstream";
        description = "Linux kernel for StarFive's VisionFive2";
        platforms = ["riscv64-linux"];
      };
    }
    // (args.argsOverride or {}))
