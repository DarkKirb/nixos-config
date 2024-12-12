{ config, ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    # Thank you amd for not supporting 11.0.1
    environmentVariables.HCC_AMDGPU_TARGET = "gfx1100";
    rocmOverrideGfx = "11.0.0";
  };
  environment.persistence."/persistent".directories = [ "/var/lib/private/ollama" ];
  systemd.tmpfiles.rules = [
    "d /var/lib/private 1777 root root - -"
  ];
}
