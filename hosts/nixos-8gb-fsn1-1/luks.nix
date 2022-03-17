{ ... }: {
  boot.initrd.luks.devices = {
    disk0 = {
      device = "/dev/disk/by-partuuid/29ccd4c9-5ef5-a146-8e42-9244f712baca";
    };
  };
}
