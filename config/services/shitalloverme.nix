{
  system,
  pkgs,
  nix-packages,
  ...
}: let
  input = "${nix-packages.packages.${system}.lotte-art}/2022-12-27-rexyi-scatych.jxl";
  sizes = [1 2 4 8 16 32 64 128 256 512 1024 2000];
  formats = ["jxl" "avif" "heic" "webp" "jpeg" "png"];
  mkImage = format: size: let
    pkg = pkgs.stdenvNoCC.mkDerivation {
      src = pkgs.emptyDirectory;
      name = "${toString size}.${format}";
      nativeBuildInputs = with pkgs; [imagemagick];
      buildPhase = ''
        mkdir $out
        convert ${input} -resize ${toString size}x${toString size} $out/${toString size}.${format}
      '';
      installPhase = "true";
    };
  in "${pkg}/${toString size}.${format}";
  files = builtins.concatMap (format: map (mkImage format) sizes) formats;
  shitalloverme = pkgs.stdenvNoCC.mkDerivation {
    src = pkgs.emptyDirectory;
    name = "shitallover.me";
    buildPhase = "true";
    installPhase = ''
      mkdir $out
      ln -sv ${../../extra/shitalloverme.html} $out/index.html
      for f in ${toString files}; do
        ln -sv $f $out
      done
    '';
  };
in {
  services.caddy.virtualHosts."shitallover.me" = {
    useACMEHost = "shitallover.me";
    extraConfig = ''
      import baseConfig

      root * ${shitalloverme}
      file_server
    '';
  };
}
