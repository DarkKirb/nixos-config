{
  config,
  pkgs,
  ...
}:
let
  nodeIPs = {
    instance-20221213-1915 = "100.99.173.107";
    nixos-8gb-fsn1-1 = "100.119.226.33";
    nas = "100.97.198.107";
    rainbow-resort = "100.115.217.35";
  };
in
{
  sops.secrets."k3s/token" = {
    sopsFile = ./secrets.yaml;
  };

  services.k3s = rec {
    enable = true;
    role = "server";
    tokenFile = config.sops.secrets."k3s/token".path;
    clusterInit = config.networking.hostName == "instance-20221213-1915";
    serverAddr = if clusterInit then "" else "https://100.99.173.107:6443";
    extraFlags =
      if config.networking.hostName == "rainbow-resort" then
        "--container-runtime-endpoint unix:///run/containerd/containerd.sock --node-ip ${
          nodeIPs.${config.networking.hostName}
        } --node-external-ip ${nodeIPs.${config.networking.hostName}} --flannel-iface tailscale0"
      else
        "--tls-san ${config.networking.hostName}.int.chir.rs --container-runtime-endpoint unix:///run/containerd/containerd.sock --advertise-address ${
          nodeIPs.${config.networking.hostName}
        }  --node-ip ${nodeIPs.${config.networking.hostName}} --node-external-ip ${
          nodeIPs.${config.networking.hostName}
        } --flannel-iface tailscale0 --cluster-cidr=10.42.0.0/16 --service-cidr=10.43.0.0/16";
  };
  virtualisation.containerd = {
    enable = true;
    settings =
      let
        fullCNIPlugins = pkgs.buildEnv {
          name = "full-cni";
          paths = with pkgs; [
            cni-plugins
            cni-plugin-flannel
          ];
        };
      in
      {
        plugins."io.containerd.grpc.v1.cri".cni = {
          bin_dir = "${fullCNIPlugins}/bin";
          conf_dir = "/var/lib/rancher/k3s/agent/etc/cni/net.d/";
        };
        # Optionally set private registry credentials here instead of using /etc/rancher/k3s/registries.yaml
        # plugins."io.containerd.grpc.v1.cri".registry.configs."registry.example.com".auth = {
        #  username = "";
        #  password = "";
        # };
      };
  };
  environment.systemPackages = [
    pkgs.nfs-utils
    pkgs.kubernetes-helm
  ];
  services.openiscsi = {
    enable = true;
    name = "${config.networking.hostName}-initiatorhost";
  };
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;
}
