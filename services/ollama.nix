{ nixpkgs-rocm-workaround, ... }:
{

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    # Thank you amd for not supporting 11.0.1
    environmentVariables.HCC_AMDGPU_TARGET = "gfx1100";
    rocmOverrideGfx = "11.0.0";
    host = "[::]";
  };
  nixpkgs.overlays = [
    (
      _: _:
      let
        pkgs' = import nixpkgs-rocm-workaround {
          system = "x86_64-linux";
        };
      in
      {
        inherit (pkgs') rocmPackages rocmPackages_5 rocmPackages_6;
      }
    )
  ];
  environment.persistence."/persistent".directories = [ "/var/lib/private/ollama" ];
}
