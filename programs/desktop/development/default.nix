{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./rust ];
  home.packages = with pkgs; [
    (python3.withPackages (_: [ ]))
    kubectl
    kubernetes-helm
    argocd
  ];
  home.sessionVariables.KUBECONFIG = config.sops.secrets.".config/kube/config".path;
  sops.secrets.".config/kube/config".sopsFile = ./secrets.yaml;
  xdg.configFile."argocd/config".text = lib.generators.toYAML { } {
    contexts = [
      {
        name = "kubernetes";
        server = "kubernetes";
        user = "kubernetes";
      }
    ];
    current-context = "kubernetes";
    prompts-enabled = false;
    servers = [
      {
        core = true;
        grpc-web-root-path = "";
        server = "kubernetes";
      }
    ];
    users = [
      { name = "kubernetes"; }
    ];
  };
}
