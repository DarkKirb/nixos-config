{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.zfs;
in {
  options = {
    zfs = {
      enable = mkEnableOption "Lotte’s ZFS Module";
      zpool = mkOption {
        default = {};
        description = ''
          zpool configuration
        '';
        type = types.attrsOf (types.submodule ({
          name,
          config,
          ...
        }: {
          options = {
            enable = mkEnableOption "zpool ${name}";
            ashift = mkOption {
              description = "Pool sector size exponent, to the power of 2 (internally referred to as ashift). Values from 9 to 16, inclusive, are valid; also, the value 0 (the default) means to auto-detect using the kernel's block layer and a ZFS internal exception list. I/O operations will be aligned to the specified size boundaries. Additionally, the minimum (disk) write size will be set to the specified size, so this represents a space/performance trade-off. For optimal performance, the pool sector size should be greater than or equal to the sector size of the underlying disks. The typical case for setting this property is when performance is important and the underlying disks use 4KiB sectors but report 512B sectors to the OS (for compatibility reasons); in that case, set ashift=12 (which is 1<<12 = 4096). When set, this property is used as the default hint value in subsequent vdev operations (add, attach and replace). Changing this value will not modify any existing vdev, not even on disk replacement; however it can be used, for instance, to replace a dying 512B sectors disk with a newer 4KiB sectors device: this will probably result in bad performance but at the same time could prevent loss of data.";
              default = 12;
              type = types.ints.between 9 16;
            };
            autoexpand = mkOption {
              description = "Controls automatic pool expansion when the underlying LUN is grown. If set to on, the pool will be resized according to the size of the expanded device. If the device is part of a mirror or raidz then all devices within that mirror/raidz group must be expanded before the new space is made available to the pool. The default behavior is off. This property can also be referred to by its shortened column name, expand.";
              default = false;
              type = types.bool;
            };
            autoreplace = mkOption {
              description = "Controls automatic device replacement. If set to off, device replacement must be initiated by the administrator by using the zpool replace command. If set to on, any new device, found in the same physical location as a device that previously belonged to the pool, is automatically formatted and replaced. The default behavior is off. This property can also be referred to by its shortened column name, replace. Autoreplace can also be used with virtual disks (like device mapper) provided that you use the /dev/disk/by-vdev paths setup by vdev_id.conf. See the vdev_id(8) manual page for more details. Autoreplace and autoonline require the ZFS Event Daemon be configured and running. See the zed(8) manual page for more details.";
              default = false;
              type = types.bool;
            };
            autotrim = mkOption {
              description = ''                When set to on space which has been recently freed, and is no longer allocated by the pool, will be periodically trimmed. This allows block device vdevs which support BLKDISCARD, such as SSDs, or file vdevs on which the underlying file system supports hole-punching, to reclaim unused blocks. The default value for this property is off.
                Automatic TRIM does not immediately reclaim blocks after a free. Instead, it will optimistically delay allowing smaller ranges to be aggregated into a few larger ones. These can then be issued more efficiently to the storage. TRIM on L2ARC devices is enabled by setting l2arc_trim_ahead > 0.
                  Be aware that automatic trimming of recently freed data blocks can put significant stress on the underlying storage devices. This will vary depending of how well the specific device handles these commands. For lower-end devices it is often possible to achieve most of the benefits of automatic trimming by running an on-demand (manual) TRIM periodically using the zpool trim command.'';
              default = false;
              type = types.bool;
            };
            bootfs = mkOption {
              description = "Identifies the default bootable dataset for the root pool. This property is expected to be set mainly by the installation and upgrade programs. Not all Linux distribution boot processes use the bootfs property.";
              default = null;
              type = types.nullOr types.str;
            };
            cachefile = mkOption {
              description = ''                Controls the location of where the pool configuration is cached. Discovering all pools on system startup requires a cached copy of the configuration data that is stored on the root file system. All pools in this cache are automatically imported when the system boots. Some environments, such as install and clustering, need to cache this information in a different location so that pools are not automatically imported. Setting this property caches the pool configuration in a different location that can later be imported with zpool import -c. Setting it to the value none creates a temporary pool that is never cached, and the “” (empty string) uses the default location.
                                 Multiple pools can share the same cache file. Because the kernel destroys and recreates this file when pools are added and removed, care should be taken when attempting to access this file. When the last pool using a cachefile is exported or destroyed, the file will be empty.
              '';
              default = null;
              type = types.nullOr types.path;
            };
            compatibility = mkOption {
              description = ''
                Specifies that the pool maintain compatibility with specific feature sets. When set to off (or unset) compatibility is disabled (all features may be enabled); when set to legacyno features may be enabled. When set to a comma-separated list of filenames (each filename may either be an absolute path, or relative to /etc/zfs/compatibility.d or /usr/share/zfs/compatibility.d) the lists of requested features are read from those files, separated by whitespace and/or commas. Only features present in all files may be enabled.
                 See zpool-features(7), zpool-create(8) and zpool-upgrade(8) for more information on the operation of compatibility feature sets.
              '';
              default = false;
              type = types.either (types.enum [false "legacy"]) (types.listOf types.path);
            };
            delegation = mkOption {
              description = ''
                Controls whether a non-privileged user is granted access based on the dataset permissions defined on the dataset. See zfs(8) for more information on ZFS delegated administration.
              '';
              default = true;
              type = types.bool;
            };
            failmode = mkOption {
              description = ''
                Controls the system behavior in the event of catastrophic pool failure. This condition is typically a result of a loss of connectivity to the underlying storage device(s) or a failure of all devices within the pool. The behavior of such an event is determined as follows:
                - wait: Blocks all I/O access until the device connectivity is recovered and the errors are cleared with zpool clear. This is the default behavior.
                - continue: Returns EIO to any new write I/O requests but allows reads to any of the remaining healthy devices. Any write requests that have yet to be committed to disk would be blocked.
                - panic: Prints out a message to the console and generates a system crash dump.
              '';
              default = "wait";
              type = types.enum ["wait" "continue" "panic"];
            };
            listsnapshots = mkOption {
              description = "Controls whether information about snapshots associated with this pool is output when zfs list is run without the -t option. The default value is off. This property can also be referred to by its shortened name, listsnaps.";
              default = false;
              type = types.bool;
            };
            multihost = mkOption {
              description = ''
                Controls whether a pool activity check should be performed during zpool import. When a pool is determined to be active it cannot be imported, even with the -f option. This property is intended to be used in failover configurations where multiple hosts have access to a pool on shared storage.
                 Multihost provides protection on import only. It does not protect against an individual device being used in multiple pools, regardless of the type of vdev. See the discussion under zpool create.
                  When this property is on, periodic writes to storage occur to show the pool is in use. See zfs_multihost_interval in the zfs(4) manual page. In order to enable this property each host must set a unique hostid. See genhostid(1) zgenhostid(8) spl(4) for additional details. The default value is off.
              '';
              default = false;
              type = types.bool;
            };
            extraProps = mkOption {
              description = ''
                extra zpool properties
              '';
              default = {};
              type = types.attrsOf types.str;
            };
          };
          config.extraProps = let
            toString = v:
              if builtins.isBool v
              then
                (
                  if v
                  then "on"
                  else "off"
                )
              else builtins.to_string v;
          in
            mkIf config.enable (mkMerge [
              {
                autoexpand = toString config.autoexpand;
                autoreplace = toString config.autoreplace;
                autotrim = toString config.autotrim;
                delegation = toString config.delegation;
                listsnapshots = toString config.listsnapshots;
                multihost = toString config.multihost;
                inherit (config) failmode;
              }
              (mkIf (config.bootfs != null) {inherit (config) bootfs;})
              (mkIf (config.cachefile != null) {inherit (config) cachefile;})
              (mkIf config.compatibility {
                compatibility =
                  if builtins.isList config.compatibility
                  then lib.lists.foldl (a: b: a ++ (toString b)) "" config.compatibility
                  else toString config.compatibility;
              })
            ]);
        }));
      };
    };
  };
  config = mkIf config.zfs.enable {
    boot = {
      # If zfs unstable is enabled, use latest supported version of linux
      # If zfs unstable is disabled, use stable version of linux, unless unsupported
      kernelPackages =
        if config.boot.zfs.enableUnstable
        then config.boot.zfs.package.latestCompatibleLinuxPackages
        else
          (
            if pkgs.linuxPackages.kernelOlder config.boot.zfs.package.latestCompatibleLinuxPackages.kernel.version
            then pkgs.linuxPackages
            else config.boot.zfs.package.latestCompatibleLinuxPackages
          );
      supportedFilesystems = ["zfs"];
    };
    systemd.services = let
      inherit (lib.attrsets) filterAttrs mapAttrs' mapAttrsToList;
      inherit (lib.strings) escapeShellArgs intersperse;
      enabledPools = filterAttrs (_: v: v.enable) cfg.zpool;
    in
      mapAttrs' (name: value: {
        name = "zfs-import-${name}";
        value.environment.ZFS_FORCE = let
          attrList = mapAttrsToList (name: value: "${name}=${value}") value.extraProps;
          forceArg =
            if config.boot.zfs.forceImportAll || config.boot.zfs.forceImportRoot
            then "-f"
            else "";
          cmdline = escapeShellArgs (intersperse "-o" ([forceArg] ++ attrList));
        in
          mkForce cmdline;
      })
      enabledPools;
  };
}
