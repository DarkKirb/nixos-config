{
  config,
  pkgs,
  modulesPath,
  lib,
  nixos-hardware,
  system,
  ...
}: {
  networking.hostName = "devterm";
  networking.hostId = "b83a2c93";

  imports = [
    ./desktop.nix
    #nixos-hardware.nixosModules.raspberry-pi-4
  ];

  /*
     hardware.raspberry-pi."4" = {
     #audio.enable = true;
     dwc2.enable = true;
     #i2c0.enable = true;
     #i2c1.enable = true;
     #fkms-3d.enable = true;
     apply-overlays-dtmerge.enable = true;
     pwm0.enable = true;
     #tc358743.enable = true;
   };
   */

  hardware.deviceTree.filter = "bcm2711-rpi-cm4.dtb";

  hardware.deviceTree.overlays = [
    {
      name = "dwc-overlay";
      dtsText = ''
        /dts-v1/;
        /plugin/;

        /{
          compatible = "brcm,bcm2711";

          fragment@0 {
            target = <&usb>;
            #address-cells = <1>;
            #size-cells = <1>;
            dwc2_usb: __overlay__ {
              compatible = "brcm,bcm2835-usb";
              dr_mode = "host";
              g-np-tx-fifo-size = <32>;
              g-rx-fifo-size = <558>;
              g-tx-fifo-size = <512 512 512 512 512 256 256>;
              status = "okay";
            };
          };

          __overrides__ {
            dr_mode = <&dwc2_usb>, "dr_mode";
            g-np-tx-fifo-size = <&dwc2_usb>,"g-np-tx-fifo-size:0";
            g-rx-fifo-size = <&dwc2_usb>,"g-rx-fifo-size:0";
          };
        };
      '';
    }
    {
      name = "cma-overlay";
      dtsText = ''
        /dts-v1/;
        /plugin/;

        / {
          compatible = "brcm,bcm2711";

          fragment@0 {
            target = <&cma>;
            frag0: __overlay__ {
              /*
               * The default size when using this overlay is 256 MB
               * and should be kept as is for backwards
               * compatibility.
               */
              size = <0x18000000>;
            };
          };

          __overrides__ {
            cma-512 = <&frag0>,"size:0=",<0x20000000>;
            cma-448 = <&frag0>,"size:0=",<0x1c000000>;
            cma-384 = <&frag0>,"size:0=",<0x18000000>;
            cma-320 = <&frag0>,"size:0=",<0x14000000>;
            cma-256 = <&frag0>,"size:0=",<0x10000000>;
            cma-192 = <&frag0>,"size:0=",<0xC000000>;
            cma-128 = <&frag0>,"size:0=",<0x8000000>;
            cma-96  = <&frag0>,"size:0=",<0x6000000>;
            cma-64  = <&frag0>,"size:0=",<0x4000000>;
            cma-size = <&frag0>,"size:0"; /* in bytes, 4MB aligned */
            cma-default = <0>,"-0";
          };
        };
      '';
    }
    {
      name = "vc4-kms-v3d-pi4-overlay";
      dtsText = ''
        /dts-v1/;
        /plugin/;

        / {
          compatible = "brcm,bcm2711";

          fragment@1 {
            target = <&ddc0>;
            __overlay__  {
              status = "okay";
            };
          };

          fragment@2 {
            target = <&ddc1>;
            __overlay__  {
              status = "okay";
            };
          };

          fragment@3 {
            target = <&hdmi0>;
            __overlay__  {
              status = "okay";
            };
          };

          fragment@4 {
            target = <&hdmi1>;
            __overlay__  {
              status = "okay";
            };
          };

          fragment@5 {
            target = <&hvs>;
            __overlay__  {
              status = "okay";
            };
          };

          fragment@6 {
            target = <&pixelvalve0>;
            __overlay__  {
              status = "okay";
            };
          };

          fragment@7 {
            target = <&pixelvalve1>;
            __overlay__  {
              status = "okay";
            };
          };

          fragment@8 {
            target = <&pixelvalve2>;
            __overlay__  {
              status = "okay";
            };
          };

          fragment@9 {
            target = <&pixelvalve3>;
            __overlay__  {
              status = "okay";
            };
          };

          fragment@10 {
            target = <&pixelvalve4>;
            __overlay__  {
              status = "okay";
            };
          };

          fragment@11 {
            target = <&v3d>;
            __overlay__  {
              status = "okay";
            };
          };

          fragment@12 {
            target = <&vc4>;
            __overlay__  {
              status = "okay";
            };
          };

          fragment@13 {
            target = <&txp>;
            __overlay__  {
              status = "okay";
            };
          };

          fragment@14 {
            target = <&fb>;
            __overlay__  {
              status = "disabled";
            };
          };

          fragment@15 {
            target = <&firmwarekms>;
            __overlay__  {
              status = "disabled";
            };
          };

          fragment@16 {
            target = <&vec>;
            __overlay__  {
              status = "disabled";
            };
          };

          fragment@17 {
            target = <&hdmi0>;
            __dormant__  {
              dmas;
            };
          };

          fragment@18 {
            target = <&hdmi1>;
            __dormant__  {
              dmas;
            };
          };

          fragment@19 {
            target = <&audio>;
            __overlay__  {
                brcm,disable-hdmi;
            };
          };

          fragment@20 {
            target = <&dvp>;
            __overlay__  {
              status = "okay";
            };
          };

          fragment@21 {
            target = <&pixelvalve3>;
            __dormant__  {
              status = "okay";
            };
          };

          fragment@22 {
            target = <&vec>;
            __dormant__  {
              status = "okay";
            };
          };

          fragment@23 {
            target = <&aon_intr>;
            __overlay__  {
              status = "okay";
            };
          };

          __overrides__ {
            audio   = <0>,"!17";
            audio1   = <0>,"!18";
            noaudio = <0>,"=17", <0>,"=18";
            composite = <0>, "!1",
                  <0>, "!2",
                  <0>, "!3",
                  <0>, "!4",
                  <0>, "!6",
                  <0>, "!7",
                  <0>, "!8",
                  <0>, "!9",
                  <0>, "!10",
                  <0>, "!16",
                  <0>, "=21",
                  <0>, "=22";
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
          compatible = "brcm,bcm2711";

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
                compatible = "cw,cwd686";
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
          compatible = "brcm,bcm2711";

          fragment@0 {
            target = <&i2c0if>;
            __overlay__ {
              #address-cells = <1>;
              #size-cells = <0>;
              pinctrl-0 = <&i2c0_pins>;
              pinctrl-names = "default";
              status = "okay";

              axp22x: pmic@34 {
                interrupt-controller;
                #interrupt-cells = <1>;
                compatible = "x-powers,axp223";
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
                    regulator-always-on;
                    regulator-min-microvolt = <3300000>;
                    regulator-max-microvolt = <3300000>;
                    regulator-name = "display-vcc";
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

                };

                battery_power_supply: battery-power-supply {
                  compatible = "x-powers,axp221-battery-power-supply";
                  monitored-battery = <&battery>;
                };

                ac_power_supply: ac_power_supply {
                  compatible = "x-powers,axp221-ac-power-supply";
                };

              };
            };
          };

          fragment@1 {
            target = <&i2c0if>;
            __overlay__ {
              compatible = "brcm,bcm2708-i2c";
            };
          };

          fragment@2 {
            target-path = "/aliases";
            __overlay__ {
              i2c0 = "/soc/i2c@7e205000";
            };
          };

          fragment@3 {
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
      name = "audremap-overlay";
      dtsText = ''
        /dts-v1/;
        /plugin/;
        / {
                compatible = "brcm,bcm2711";

                fragment@0 {
                        target = <&audio_pins>;
                        frag0: __overlay__ {
                        };
                };

          fragment@1 {
                        target = <&audio_pins>;
                        __overlay__ {
                                brcm,pins = < 12 13 >;
                                brcm,function = < 4 >; /* alt0 alt0 */
                        };
                };

          fragment@2 {
            target = <&audio_pins>;
            __dormant__ {
                                brcm,pins = < 18 19 >;
                                brcm,function = < 2 >; /* alt5 alt5 */
            };
          };

          fragment@3 {
            target = <&audio>;
            __overlay__  {
              brcm,disable-headphones = <0>;
            };
          };

          __overrides__ {
            swap_lr = <&frag0>, "swap_lr?";
            enable_jack = <&frag0>, "enable_jack?";
            pins_12_13 = <0>,"+1-2";
            pins_18_19 = <0>,"-1+2";
          };
        };
      '';
    }
    {
      name = "gpio-fan-overlay";
      dtsText = ''
        /*
         * Overlay for the Raspberry Pi GPIO Fan @ BCM GPIO12.
         * References:
         *  - https://www.raspberrypi.org/forums/viewtopic.php?f=107&p=1367135#p1365084
         *
         * Optional parameters:
         *  - "gpiopin"  - BCM number of the pin driving the fan, default 12 (GPIO12);
         *   - "temp"  - CPU temperature at which fan is started in millicelsius, default 55000;
         *
         * Requires:
         *  - kernel configurations: CONFIG_SENSORS_GPIO_FAN=m;
         *  - kernel rebuild;
         *  - N-MOSFET connected to gpiopin, 2N7002-[https://en.wikipedia.org/wiki/2N7000];
         *  - DC Fan connected to N-MOSFET Drain terminal, a 12V fan is working fine and quite silently;
         *    [https://www.tme.eu/en/details/ee40101s1-999-a/dc12v-fans/sunon/ee40101s1-1000u-999/]
         *
         *                   ┌─────────────────────┐
         *                   │Fan negative terminal│
         *                   └┬────────────────────┘
         *                    │D
         *             G   │──┘
         * [GPIO12]──────┤ │<─┐  2N7002
         *                 │──┤
         *                    │S
         *                   ─┴─
         *                   GND
         *
         * Build:
         *   - `sudo dtc -W no-unit_address_vs_reg -@ -I dts -O dtb -o /boot/overlays/gpio-fan.dtbo gpio-fan-overlay.dts`
         * Activate:
         *  - sudo nano /boot/config.txt add "dtoverlay=gpio-fan" or "dtoverlay=gpio-fan,gpiopin=12,temp=45000"
         *   or
         *  - sudo sh -c 'printf "\n# Enable PI GPIO-Fan Default\ndtoverlay=gpio-fan\n" >> /boot/config.txt'
         *  - sudo sh -c 'printf "\n# Enable PI GPIO-Fan Custom\ndtoverlay=gpio-fan,gpiopin=12,temp=45000\n" >> /boot/config.txt'
         *
         */
        /dts-v1/;
        /plugin/;

        / {
          compatible = "brcm,bcm2835";

          fragment@0 {
            target-path = "/";
            __overlay__ {
              fan0: gpio-fan@0 {
                compatible = "gpio-fan";
                gpios = <&gpio 12 0>;
                gpio-fan,speed-map = <0    0>,
                           <5000 1>;
                #cooling-cells = <2>;
              };
            };
          };

          fragment@1 {
            target = <&cpu_thermal>;
            polling-delay = <2000>;  /* milliseconds */
            __overlay__ {
              trips {
                cpu_hot: trip-point@0 {
                  temperature = <55000>;  /* (millicelsius) Fan started at 55°C */
                  hysteresis = <10000>;  /* (millicelsius) Fan stopped at 45°C */
                  type = "active";
                };
              };
              cooling-maps {
                map0 {
                  trip = <&cpu_hot>;
                  cooling-device = <&fan0 1 1>;
                };
              };
            };
          };
          __overrides__ {
            gpiopin = <&fan0>,"gpios:4", <&fan0>,"brcm,pins:0";
            temp = <&cpu_hot>,"temperature:0";
          };
        };
      '';
    }
    {
      name = "audio-on-overlay";
      dtsText = ''
        /dts-v1/;
        /plugin/;
        / {
          compatible = "brcm,bcm2711";
          fragment@0 {
            target = <&audio>;

            __overlay__ {
              status = "okay";
            };
          };
        };
      '';
    }
  ];

  services.xserver.videoDrivers = lib.mkBefore [
    "modesetting" # Prefer the modesetting driver in X11
    "fbdev" # Fallback to fbdev
  ];

  nixpkgs.overlays = [
    (self: super: {
      deviceTree.applyOverlays = self.callPackage "${nixos-hardware}/raspberry-pi/4/apply-overlays-dtmerge.nix" {};
    })
  ];

  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor ((pkgs.linux_rpi4.override {
      kernelPatches = [
        {
          name = "devterm";
          patch = ../overlays/rpi.patch;
        }
      ];
      structuredExtraConfig = with lib.kernel; {
        WERROR = no;
        DRM_AST = no;
        DEBUG_INFO_BTF = lib.mkForce no;
        DRM_PANEL_CWD686 = module;
        BACKLIGHT_OCP8178 = module;
      };
      argsOverride = {
        src = pkgs.fetchFromGitHub {
          owner = "raspberrypi";
          repo = "linux";
          rev = "rpi-5.10.y";
          sha256 = "154aicn2cd4a6kpnifcb899px6jijg2abavjm3y4w5lfwpipmqck";
        };
        version = "5.10.17-devterm";
        modDirVersion = "5.10.17";
        extraMeta.branch = "5.10";
      };
    })
    .overrideDerivation
    (super: {
      nativeBuildInputs = super.nativeBuildInputs ++ [pkgs.python3];
      buildInputs = super.buildInputs ++ [pkgs.python3];
      patchPhase =
        super.patchPhase
        or ""
        + ''
          find tools -name Makefile -exec sed -i 's/-Werror//g' {} '+'
          patchShebangs --host .
        '';
      postFixup = "";
    })));

  boot = {
    initrd.availableKernelModules = [
      "usbhid"
      "usb_storage"
      "vc4"
      "pcie_brcmstb" # required for the pcie bus to work
      "reset-raspberrypi" # required for vl805 firmware to load
      "axp20x_adc"
      "axp20x_ac_power"
      "axp20x_battery"
      "axp20x_usb_power"
      "axp20x_regulator"
      "axp20x-pek"
      "axp20x-i2c"
      "i2c-bcm2835"
      "ti-adc081c"
      "ocp8178"
      "cwd686"
    ];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "btrfs";
      options = ["noatime"];
    };
  };
  boot.supportedFilesystems = lib.mkForce ["btrfs" "vfat"];
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
  hardware.pulseaudio.configFile = lib.mkOverride 990 (pkgs.runCommand "default.pa" {} ''
    sed 's/module-udev-detect$/module-udev-detect tsched=0/' ${config.hardware.pulseaudio.package}/etc/pulse/default.pa > $out
  '');
}
