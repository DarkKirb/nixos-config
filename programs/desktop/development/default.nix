{ config, pkgs, ... }:
{
  imports = [ ./rust ];
  home.packages = with pkgs; [
    (python3.withPackages (_: [ ]))
    kubectl
    kubernetes-helm
  ];
  home.sessionVariables.KUBECONFIG = config.sops.secrets.".config/kube/config".path;
  sops.secrets.".config/kube/config".sopsFile = ./secrets.yaml;
}
