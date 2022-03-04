{ pkgs, ... }:
let
  plover-src = pkgs.plover.dev.src;
in
{
  home.packages = [
    pkgs.plover.dev
  ];
  home.file = {
    ".config/plover/main.json".source = "${plover-src}/plover/assets/main.json";
    ".config/plover/commands.json".source = "${plover-src}/plover/assets/commands.json";
    ".config/plover/user.json".text = builtins.toJSON {
      "SER/TKPWAL" = "Sergal";
      "SERLG" = "Sergal";
    };
  };
}
