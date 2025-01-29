{ nixpkgs-rocm-workaround, ... }:
{

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    host = "[::]";
  };
  nixpkgs.overlays = [
    (
      _: _:
      let
        pkgs' = import nixpkgs-rocm-workaround { };
      in
      {
        inherit (pkgs') rocmPackages rocmPackages_5 rocmPackages_6;
      }
    )
  ];
  environment.persistence."/persistent".directories = [ "/var/lib/private/ollama" ];
}
