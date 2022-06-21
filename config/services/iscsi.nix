{
  config,
  pkgs,
  ...
}: {
  systemd.packages = [pkgs.tgt];
  systemd.services."tgtd".wantedBy = ["multi-user.target"];
  networking.firewall.interfaces."br0".allowedTCPPorts = [860 3260];
  environment.etc."tgt/targets.conf".text = ''
    default-driver iscsi

    <target iqn.2022-06.rs.chir:rs.chir.int.nas.windows>
      backing-store /dev/tank/iscsi/windows
    </target>
  '';
}
