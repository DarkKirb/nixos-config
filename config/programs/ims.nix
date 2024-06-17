{
  system,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      (element-desktop.override (_: {
        electron = pkgs.electron-bin;
      }))
      twinkle
    ]
    ++ (
      if system == "x86_64-linux"
      then [
        pkgs.discord
      ]
      else []
    );
}
