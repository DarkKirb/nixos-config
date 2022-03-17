{ ... }: {
  boot.initrd.luks.devices = {
    ssd = {
      device = "/dev/disk/by-partuuid/53773b73-fb8a-4de8-ac58-d9d8ff1be430";
      allowDiscards = true;
    };
    hdd = {
      device = "/dev/disk/by-partuuid/d4c6a94f-2ae9-e446-9613-2596c564078c";
    };
  };
}
