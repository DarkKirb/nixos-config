# Configuration unique to servers
{ ... }: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:DarkKirb/nixos-config";
    flags = [
      "--recreate-lock-file"
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "daily";
  };
}
