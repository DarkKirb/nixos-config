{pkgs, ...}: {
  home.packages = with pkgs;
    if system == "x86_64-linux"
    then [
      cinny-desktop
      element-desktop
    ]
    else [nheko];
}
