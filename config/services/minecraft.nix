{ ... }: {
  imports = [
    ../../modules/minecraft.nix
  ];

  services.minecraft = {
    enable = true;
  };
}
