{pkgs, ...}: {
  systemd.packages = with pkgs; [ nfs-utils ];
    services.nfs.server = {
        enable = true;
        exports = ''
            /export/vf2 192.168.2.1/24(rw,no_root_squash,async,nohide,no_subtree_check)
        '';
        extraNfsdConfig = '''';
    };
    networking.firewall = {
        allowedTCPPorts = [ 111  2049 4000 4001 4002 20048 ];
        allowedUDPPorts = [ 111  2049 4000 4001 4002 20048 ];
    };
}
