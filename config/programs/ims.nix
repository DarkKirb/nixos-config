{
  system,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      nheko
      twinkle
      tokodon
    ]
    ++ (
      if system == "x86_64-linux"
      then [
        pkgs.discord
      ]
      else []
    );
}
