{
  config,
  pkgs,
  modulesPath,
  lib,
  nixos-hardware,
  system,
  nix-packages,
  ...
}: {
  networking.hostName = "devterm";
  networking.hostId = "b83a2c93";

  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor nix-packages.packages.${system}.rpi4Kernel);

  hardware.deviceTree.overlays = [
    {
      name = "devterm-bt";
      dtsText = ''
        /dts-v1/;
        /plugin/;

        /{
          compatible = "brcm,bcm2835";

          fragment@0 {
            target = <&uart0>;
            __overlay__ {
              pinctrl-names = "default";
              pinctrl-0 = <&uart0_pins &bt_pins>;
              status = "okay";
            };
          };

          fragment@1 {
            target = <&gpio>;
            __overlay__ {
              uart0_pins: uart0_pins {
                brcm,pins = <14 15 16 17>;
                brcm,function = <4 4 7 7>;
                brcm,pull = <0 2 0 2>;
              };

              bt_pins: bt_pins {
                brcm,pins = <5 6 7>;
                brcm,function = <1 0 1>;
                brcm,pull = <0 2 0>;
              };
            };
          };

          fragment@2 {
            target-path = "/aliases";
            __overlay__ {
              serial1 = "/soc/serial@7e201000";
              serial0 = "/soc/serial@7e215040";
            };
          };
        };
      '';
    }

    {
      name = "devterm-misc";
      dtsText = ''
        /dts-v1/;
        /plugin/;

        /{
          compatible = "brcm,bcm2835";

          fragment@0 {
            target = <&pwm>;
            __overlay__ {
              pinctrl-names = "default";
              pinctrl-0 = <&pwm_pins>;
              assigned-clock-rates = <100000000>;
              status = "okay";
            };
          };

          fragment@1 {
            target = <&i2c1>;
            __overlay__ {
              #address-cells = <1>;
              #size-cells = <0>;
              pinctrl-names = "default";
              pinctrl-0 = <&i2c1_pins>;
              status = "okay";

              adc101c: adc@54 {
                reg = <0x54>;
                compatible = "ti,adc101c";
                status = "okay";
              };

            };
          };

          fragment@2 {
            target = <&spi0>;
            __overlay__ {
              pinctrl-names = "default";
              pinctrl-0 = <&spi0_pins &spi0_cs_pins>;
              cs-gpios = <&gpio 35 1>;
              status = "okay";
            };
          };

          fragment@3 {
            target = <&uart1>;
            __overlay__ {
              pinctrl-names = "default";
              pinctrl-0 = <&uart1_pins>;
              status = "okay";
            };
          };

          fragment@4 {
            target = <&gpio>;
            __overlay__ {

              pwm_pins: pwm_pins {
                brcm,pins = <12 13>;
                brcm,function = <4>;
              };

              i2c1_pins: i2c1 {
                brcm,pins = <44 45>;
                brcm,function = <6>;
              };

              spi0_pins: spi0_pins {
                brcm,pins = <38 39>;
                brcm,function = <4>;
              };

              spi0_cs_pins: spi0_cs_pins {
                brcm,pins = <35>;
                brcm,function = <1>;
              };

              uart1_pins: uart1_pins {
                brcm,pins = <32 33>;
                brcm,function = <2>;
                brcm,pull = <0 2>;
              };

            };
          };

          fragment@5 {
            target-path = "/chosen";
            __overlay__ {
              bootargs = "8250.nr_uarts=1";
            };
          };

        };
      '';
    }

    {
      name = "devterm-panel-overlay";
      dtsText = ''
        /dts-v1/;
        /plugin/;

        / {
          compatible = "brcm,bcm2835";

          fragment@0 {
            target=<&dsi1>;
            __overlay__ {
              #address-cells = <1>;
              #size-cells = <0>;
              status = "okay";

              port {
                dsi_out_port: endpoint {
                  remote-endpoint = <&panel_dsi_port>;
                };
              };

              panel_cwd686: panel@0 {
                compatible = "clockworkpi,cwd686";
                reg = <0>;
                reset-gpio = <&gpio 8 1>;
                backlight = <&ocp8178_backlight>;

                port {
                  panel_dsi_port: endpoint {
                    remote-endpoint = <&dsi_out_port>;
                  };
                };
              };
            };
          };

          fragment@1 {
            target-path = "/";
            __overlay__  {
              ocp8178_backlight: backlight@0 {
                compatible = "ocp8178-backlight";
                backlight-control-gpios = <&gpio 9 0>;
                default-brightness = <5>;
              };
            };
          };

        };
      '';
    }
    {
      name = "devterm-pmu-overlay";
      dtsText = ''
        /dts-v1/;
        /plugin/;

        / {
          compatible = "brcm,bcm2835";

          fragment@0 {
            target = <&i2c0>;
            __overlay__ {
              #address-cells = <1>;
              #size-cells = <0>;
              pinctrl-0 = <&i2c0_pins>;
              pinctrl-names = "default";
              status = "okay";

              axp22x: pmic@34 {
                interrupt-controller;
                #interrupt-cells = <1>;
                compatible = "x-powers,axp221";
                reg = <0x34>; /* i2c address */
                interrupt-parent = <&gpio>;
                interrupts = <2 8>;  /* IRQ_TYPE_EDGE_FALLING */
                irq-gpios = <&gpio 2 0>;

                regulators {

                  x-powers,dcdc-freq = <3000>;

                  reg_aldo1: aldo1 {
                    regulator-always-on;
                    regulator-min-microvolt = <3300000>;
                    regulator-max-microvolt = <3300000>;
                    regulator-name = "audio-vdd";
                  };

                  reg_aldo2: aldo2 {
                    regulator-min-microvolt = <3300000>;
                    regulator-max-microvolt = <3300000>;
                    regulator-name = "display-vcc";
                  };

                  reg_aldo3: aldo3 {
                    regulator-always-on;
                    regulator-min-microvolt = <3300000>;
                    regulator-max-microvolt = <3300000>;
                    regulator-name = "wifi-vdd";
                  };

                  reg_dldo1: dldo1 {
                    regulator-always-on;
                    regulator-min-microvolt = <3300000>;
                    regulator-max-microvolt = <3300000>;
                    regulator-name = "wifi-vcc1";
                  };

                  reg_dldo2: dldo2 {
                    regulator-always-on;
                    regulator-min-microvolt = <3300000>;
                    regulator-max-microvolt = <3300000>;
                    regulator-name = "dldo2";
                  };

                  reg_dldo3: dldo3 {
                    regulator-always-on;
                    regulator-min-microvolt = <3300000>;
                    regulator-max-microvolt = <3300000>;
                    regulator-name = "dldo3";
                  };

                  reg_dldo4: dldo4 {
                    regulator-always-on;
                    regulator-min-microvolt = <3300000>;
                    regulator-max-microvolt = <3300000>;
                    regulator-name = "dldo4";
                  };

                  reg_eldo1: eldo1 {
                    regulator-always-on;
                    regulator-min-microvolt = <3300000>;
                    regulator-max-microvolt = <3300000>;
                    regulator-name = "wifi-vcc2";
                  };

                  reg_eldo2: eldo2 {
                    regulator-always-on;
                    regulator-min-microvolt = <3300000>;
                    regulator-max-microvolt = <3300000>;
                    regulator-name = "wifi-vcc3";
                  };

                  reg_eldo3: eldo3 {
                    regulator-always-on;
                    regulator-min-microvolt = <3300000>;
                    regulator-max-microvolt = <3300000>;
                    regulator-name = "wifi-vcc4";
                  };

                };

                battery_power_supply: battery-power-supply {
                  compatible = "x-powers,axp221-battery-power-supply";
                  monitored-battery = <&battery>;
                };

                usb_power_supply: usb_power_supply {
                  compatible = "x-powers,axp221-usb-power-supply";
                };

              };
            };
          };

          fragment@1 {
            target-path = "/";
            __overlay__  {
              battery: battery@0 {
                compatible = "simple-battery";
                constant_charge_current_max_microamp = <2100000>;
                voltage-min-design-microvolt = <3300000>;
              };
            };
          };

        };
      '';
    }
    {
      name = "devterm-wifi-overlay";
      dtsText = ''
        /dts-v1/;
        /plugin/;

        /* Enable SDIO from MMC interface via various GPIO groups */

        /{
          compatible = "brcm,bcm2835";

          fragment@0 {
            target = <&mmc>;
            sdio_ovl: __overlay__ {
              pinctrl-0 = <&sdio_ovl_pins>;
              pinctrl-names = "default";
              non-removable;
              bus-width = <4>;
              status = "okay";
            };
          };

          fragment@1 {
            target = <&gpio>;
            __overlay__ {
              sdio_ovl_pins: sdio_ovl_pins {
                brcm,pins = <22 23 24 25 26 27>;
                brcm,function = <7>; /* ALT3 = SD1 */
                brcm,pull = <0 2 2 2 2 2>;
              };
            };
          };

          fragment@2 {
            target-path = "/";
            __overlay__  {
              wifi_pwrseq: wifi-pwrseq {
                compatible = "mmc-pwrseq-simple";
                reset-gpios = <&gpio 3 0>;
              };
            };
          };

        };
      '';
    }
  ];

  boot.kernelPatches = [
    {
      name = "devterm-cm4";
      patch = ./workarounds/devterm-kernel.patch;
    }
  ];

  imports = [
    ./desktop.nix
    nixos-hardware.nixosModules.raspberry-pi-4
  ];

  hardware.raspberry-pi."4" = {
    dwc2.enable = true;
    i2c1.enable = true;
    apply-overlays-dtmerge.enable = true;
    pwm0.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };
  boot.supportedFilesystems = lib.mkForce ["ext4" "vfat"];
  system.stateVersion = "22.11";
  nix.settings.cores = 4;
  networking.networkmanager.enable = true;
  users.users.darkkirb.extraGroups = ["networkmanager"];
  nix.settings.max-jobs = 4;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
  services.joycond.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.tailscale.useRoutingFeatures = "client";
}
