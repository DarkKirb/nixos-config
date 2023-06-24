{
  config,
  pkgs,
  ...
}: {
  systemd.packages = [pkgs.tgt];
  systemd.services."tgtd".wantedBy = ["multi-user.target"];
  systemd.services.tgtd.serviceConfig.execStartPost = "${pkgs.tgt}/bin/tgtadm --op new --mode logicalunit --tid 1 --lun 1 -b /export/vf2.img";
  networking.firewall.interfaces."br0".allowedTCPPorts = [860 3260];
  environment.etc."tgt/targets.conf".text = ''
    default-driver iscsi

    <target iqn.2023-06.rs.chir:rs.chir.int.nas.vf2>
      backing-store /expport/vf2.img
    </target>
  '';
}
