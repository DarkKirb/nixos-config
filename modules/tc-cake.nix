# Taken from https://github.com/mrobbetts/nixos_extra_modules/blob/main/tc_cake.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.networking.tc_cake;

  generateUnit = name: opts:
    nameValuePair "tc_cake-${name}" {
      description = "AQM (Cake) rules for ${name}.";
      bindsTo = ["sys-subsystem-net-devices-${name}.device"];
      after = ["sys-subsystem-net-devices-${name}.device" "network-pre.target"];
      requires = ["sys-subsystem-net-devices-${name}.device"];

      before = ["network.target"];
      wantedBy = ["sys-subsystem-net-devices-${name}.device"];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeTextFile {
          name = "tc-${name}-start";
          executable = true;
          text = ''
            #! ${pkgs.runtimeShell} -e

            # Offloading.
            ${optionalString opts.disableOffload ''
              ${pkgs.ethtool}/bin/ethtool -K ${name} gro off gso off tso off
            ''}

            # Make sure that the cake is reset
            ${optionalString (opts.shapeEgress.bandwidth != null) ''
              ${pkgs.iproute}/bin/tc qdisc del dev ${name} root || true
              ${pkgs.iproute}/bin/tc qdisc del dev ${name} ingress || true
            ''}
            ${optionalString (opts.shapeIngress.bandwidth != null) ''
              ${pkgs.iproute}/bin/tc qdisc del dev ${opts.shapeIngress.ifb} root || true
              ${pkgs.iproute}/bin/tc qdisc del dev ${opts.shapeIngress.ifb} ingress || true
            ''}

            # Ingress control.
            ${optionalString (opts.shapeIngress.bandwidth != null) ''
              ${pkgs.iproute}/bin/tc qdisc add dev ${name} handle ffff: ingress
              ${pkgs.iproute}/bin/ip link add name ${opts.shapeIngress.ifb} type ifb || true
              ${pkgs.iproute}/bin/ip link set ${opts.shapeIngress.ifb} up
              ${pkgs.iproute}/bin/tc qdisc add dev ${opts.shapeIngress.ifb} root cake bandwidth ${opts.shapeIngress.bandwidth} ingress
              ${pkgs.iproute}/bin/tc filter add dev ${name} parent ffff: protocol all u32 match u32 0 0 action mirred egress redirect dev ${opts.shapeIngress.ifb}
            ''}

            # Egress control.
            ${optionalString (opts.shapeEgress.bandwidth != null) ''
              ${pkgs.iproute}/bin/tc qdisc add dev ${name} root cake bandwidth ${opts.shapeEgress.bandwidth} ${opts.shapeEgress.extraArgs}
            ''}
          '';
        };

        ExecStop = pkgs.writeTextFile {
          name = "tc-${name}-stop";
          executable = true;
          text = ''
            #! ${pkgs.runtimeShell} -e

            # Ingress control.
            ${optionalString (opts.shapeIngress.bandwidth != null) ''
              ${pkgs.iproute}/bin/tc qdisc del dev ${opts.shapeIngress.ifb} root
              ${pkgs.iproute}/bin/tc qdisc del dev ${name} parent ffff:
            ''}

            # Egress control.
            ${optionalString (opts.shapeEgress.bandwidth != null) ''
              ${pkgs.iproute}/bin/tc qdisc del dev ${name} root
            ''}

            # Offloading.
            ${optionalString opts.disableOffload ''
              ${pkgs.ethtool}/bin/ethtool -K ${name} gro on gso on tso on
            ''}
          '';
        };
      };

      restartIfChanged = true;
    };
in {
  ###### interface

  options = {
    networking.tc_cake = mkOption {
      default = {};
      type = types.attrsOf (types.submodule {
        options = {
          disableOffload = mkOption {
            default = false;
            type = types.bool;
            description = ''
              Enabling this will ensure all hardware offloading (to the NIC) is disabled.
            '';
          };

          shapeEgress = mkOption {
            type = types.submodule {
              options = {
                bandwidth = mkOption {
                  default = null;
                  type = types.nullOr types.str;
                  example = "16mbit";
                  description = ''
                    A string describing the available outgoing bandwidth, compatible with `tc`.
                  '';
                };

                extraArgs = mkOption {
                  default = "";
                  type = types.str;
                  example = "nat overhead 18 mpu 64 noatm ack-filter";
                  description = ''
                    Additional arguments/flags for the cake qdisc creation.
                  '';
                };
              };
            };
            default = {
              bandwidth = null;
              extraArgs = "";
            };
            description = ''
              Submodule describing how to shape egress traffic.
            '';
          };

          shapeIngress = mkOption {
            type = types.submodule {
              options = {
                bandwidth = mkOption {
                  default = null;
                  type = types.nullOr types.str;
                  example = "75mbit";
                  description = ''
                    A string describing the available incoming bandwidth, compatible with `tc`.
                  '';
                };

                ifb = mkOption {
                  default = "ifb0";
                  type = types.str;
                  example = "ifb0";
                  description = ''
                    The IFB device to use during ingress shaping. Must be unique to this interface.
                  '';
                };
              };
            };
            default = {
              bandwidth = null;
              ifb = "ifb0";
            };
            description = ''
              Submodule describing how to shape ingress traffic.
            '';
          };
        };
      });
      description = ''
        The list of traffic control commands, one entry per interface.
      '';
    };
  };

  ###### Implementation

  config = mkIf (cfg != {}) {
    #   systemd.services = mapAttrs generateUnit cfg;
    systemd.services = listToAttrs (mapAttrsToList generateUnit cfg);

    boot.kernelModules = [
      "ifb"
      "sch_cake"
      "sch_red"
      "mirred"
    ];
  };
}
