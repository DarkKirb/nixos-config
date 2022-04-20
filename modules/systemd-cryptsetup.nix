{ config, lib, pkgs, ... }:

with lib;

let
  luks = config.boot.initrd.luks;
  kernelPackages = config.boot.kernelPackages;

  commonFunctions = ''
    die() {
        echo "$@" >&2
        exit 1
    }

    dev_exist() {
        local target="$1"
        if [ -e $target ]; then
            return 0
        else
            local uuid=$(echo -n $target | sed -e 's,UUID=\(.*\),\1,g')
            blkid --uuid $uuid >/dev/null
            return $?
        fi
    }

    wait_target() {
        local name="$1"
        local target="$2"
        local secs="''${3:-10}"
        local desc="''${4:-$name $target to appear}"

        if ! dev_exist $target; then
            echo -n "Waiting $secs seconds for $desc..."
            local success=false;
            for try in $(seq $secs); do
                echo -n "."
                sleep 1
                if dev_exist $target; then
                    success=true
                    break
                fi
            done
            if [ $success == true ]; then
                echo " - success";
                return 0
            else
                echo " - failure";
                return 1
            fi
        fi
        return 0
    }
  '';

  preCommands = ''
    # A place to store crypto things

    # A ramfs is used here to ensure that the file used to update
    # the key slot with cryptsetup will never get swapped out.
    # Warning: Do NOT replace with tmpfs!
    mkdir -p /crypt-ramfs
    mount -t ramfs none /crypt-ramfs

    # Cryptsetup locking directory
    mkdir -p /run/cryptsetup

    # Disable all input echo for the whole stage. We could use read -s
    # instead but that would ocasionally leak characters between read
    # invocations.
    stty -echo
  '';

  postCommands = ''
    stty echo
    umount /crypt-storage 2>/dev/null
    umount /crypt-ramfs 2>/dev/null
  '';

  openCommand = name: dev: assert name == dev.name;
    let
      csopen = "systemd-cryptsetup attach ${dev.name} ${dev.device} \"\" tpm2-device=/dev/tpmrm0"
        + optionalString dev.allowDiscards ",discard"
        + optionalString dev.bypassWorkqueues ",no-read-workqueue,no-write-workqueue"
        + optionalString (dev.header != null) ",header=${dev.header}";
    in
    ''
      # Wait for luksRoot (and optionally keyFile and/or header) to appear, e.g.
      # if on a USB drive.
      wait_target "device" ${dev.device} || die "${dev.device} is unavailable"

      ${optionalString (dev.header != null) ''
        wait_target "header" ${dev.header} || die "${dev.header} is unavailable"
      ''}

      # commands to run right before we mount our device
      ${dev.preOpenCommands}

      ${csopen}

      # commands to run right after we mounted our device
      ${dev.postOpenCommands}
    '';

  askPass = pkgs.writeScriptBin "cryptsetup-askpass" ''
    #!/bin/sh

    ${commonFunctions}

    while true; do
        wait_target "luks" /crypt-ramfs/device 10 "LUKS to request a passphrase" || die "Passphrase is not requested now"
        device=$(cat /crypt-ramfs/device)

        echo -n "Passphrase for $device: "
        IFS= read -rs passphrase
        echo

        rm /crypt-ramfs/device
        echo -n "$passphrase" > /crypt-ramfs/passphrase
    done
  '';

  preLVM = filterAttrs (n: v: v.preLVM) luks.devices;
  postLVM = filterAttrs (n: v: !v.preLVM) luks.devices;

in
{
  imports = [
    (mkRemovedOptionModule [ "boot" "initrd" "luks" "enable" ] "")
  ];

  options = {

    boot.initrd.luks.mitigateDMAAttacks = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Unless enabled, encryption keys can be easily recovered by an attacker with physical
        access to any machine with PCMCIA, ExpressCard, ThunderBolt or FireWire port.
        More information is available at <link xlink:href="http://en.wikipedia.org/wiki/DMA_attack"/>.

        This option blacklists FireWire drivers, but doesn't remove them. You can manually
        load the drivers if you need to use a FireWire device, but don't forget to unload them!
      '';
    };

    boot.initrd.luks.cryptoModules = mkOption {
      type = types.listOf types.str;
      default =
        [
          "aes"
          "aes_generic"
          "blowfish"
          "twofish"
          "serpent"
          "cbc"
          "xts"
          "lrw"
          "sha1"
          "sha256"
          "sha512"
          "af_alg"
          "algif_skcipher"
        ];
      description = ''
        A list of cryptographic kernel modules needed to decrypt the root device(s).
        The default includes all common modules.
      '';
    };

    boot.initrd.luks.forceLuksSupportInInitrd = mkOption {
      type = types.bool;
      default = false;
      internal = true;
      description = ''
        Whether to configure luks support in the initrd, when no luks
        devices are configured.
      '';
    };

    boot.initrd.luks.devices = mkOption {
      default = { };
      example = { luksroot.device = "/dev/disk/by-uuid/430e9eff-d852-4f68-aa3b-2fa3599ebe08"; };
      description = ''
        The encrypted disk that should be opened before the root
        filesystem is mounted. Both LVM-over-LUKS and LUKS-over-LVM
        setups are supported. The unencrypted devices can be accessed as
        <filename>/dev/mapper/<replaceable>name</replaceable></filename>.
      '';

      type = with types; attrsOf (submodule (
        { name, ... }: {
          options = {

            name = mkOption {
              visible = false;
              default = name;
              example = "luksroot";
              type = types.str;
              description = "Name of the unencrypted device in <filename>/dev/mapper</filename>.";
            };

            device = mkOption {
              example = "/dev/disk/by-uuid/430e9eff-d852-4f68-aa3b-2fa3599ebe08";
              type = types.str;
              description = "Path of the underlying encrypted block device.";
            };

            header = mkOption {
              default = null;
              example = "/root/header.img";
              type = types.nullOr types.str;
              description = ''
                The name of the file or block device that
                should be used as header for the encrypted device.
              '';
            };

            # FIXME: get rid of this option.
            preLVM = mkOption {
              default = true;
              type = types.bool;
              description = "Whether the luksOpen will be attempted before LVM scan or after it.";
            };

            allowDiscards = mkOption {
              default = false;
              type = types.bool;
              description = ''
                Whether to allow TRIM requests to the underlying device. This option
                has security implications; please read the LUKS documentation before
                activating it.
                This option is incompatible with authenticated encryption (dm-crypt
                stacked over dm-integrity).
              '';
            };

            bypassWorkqueues = mkOption {
              default = false;
              type = types.bool;
              description = ''
                Whether to bypass dm-crypt's internal read and write workqueues.
                Enabling this should improve performance on SSDs; see
                <link xlink:href="https://wiki.archlinux.org/index.php/Dm-crypt/Specialties#Disable_workqueue_for_increased_solid_state_drive_(SSD)_performance">here</link>
                for more information. Needs Linux 5.9 or later.
              '';
            };

            preOpenCommands = mkOption {
              type = types.lines;
              default = "";
              example = ''
                mkdir -p /tmp/persistent
                mount -t zfs rpool/safe/persistent /tmp/persistent
              '';
              description = ''
                Commands that should be run right before we try to mount our LUKS device.
                This can be useful, if the keys needed to open the drive is on another partion.
              '';
            };

            postOpenCommands = mkOption {
              type = types.lines;
              default = "";
              example = ''
                umount /tmp/persistent
              '';
              description = ''
                Commands that should be run right after we have mounted our LUKS device.
              '';
            };
          };
        }
      ));
    };
  };

  disabledModules = [ "system/boot/luksroot.nix" ];

  config = mkIf (luks.devices != { } || luks.forceLuksSupportInInitrd) {

    assertions = [{
      assertion = any (dev: dev.bypassWorkqueues) (attrValues luks.devices)
        -> versionAtLeast kernelPackages.kernel.version "5.9";
      message = "boot.initrd.luks.devices.<name>.bypassWorkqueues is not supported for kernels older than 5.9";
    }];

    boot.initrd.kernelModules = [ "tpm" ];

    # actually, sbp2 driver is the one enabling the DMA attack, but this needs to be tested
    boot.blacklistedKernelModules = optionals luks.mitigateDMAAttacks
      [ "firewire_ohci" "firewire_core" "firewire_sbp2" ];

    # Some modules that may be needed for mounting anything ciphered
    boot.initrd.availableKernelModules = [ "dm_mod" "dm_crypt" "cryptd" "input_leds" ]
      ++ luks.cryptoModules
      # workaround until https://marc.info/?l=linux-crypto-vger&m=148783562211457&w=4 is merged
      # remove once 'modprobe --show-depends xts' shows ecb as a dependency
      ++ (if builtins.elem "xts" luks.cryptoModules then [ "ecb" ] else [ ]);

    # copy the cryptsetup binary and it's dependencies
    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.cryptsetup}/bin/cryptsetup
      copy_bin_and_libs ${askPass}/bin/cryptsetup-askpass
      sed -i s,/bin/sh,$out/bin/sh, $out/bin/cryptsetup-askpass
      copy_bin_and_libs ${pkgs.systemd}/lib/systemd/systemd-cryptsetup
      # copy tpm2 libraries manually
      cp -rpv ${pkgs.tpm2-tss}/lib/*.so* $out/lib/
    '';

    boot.initrd.extraUtilsCommandsTest = ''
      $out/bin/cryptsetup --version
      $out/bin/systemd-cryptsetup
    '';

    boot.initrd.preFailCommands = postCommands;
    boot.initrd.preLVMCommands = commonFunctions + preCommands + concatStrings (mapAttrsToList openCommand preLVM) + postCommands;
    boot.initrd.postDeviceCommands = commonFunctions + preCommands + concatStrings (mapAttrsToList openCommand postLVM) + postCommands;

    environment.systemPackages = [ pkgs.cryptsetup ];
  };
}
