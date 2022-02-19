{ ... }: {
  imports = [
    ../../modules/minecraft.nix
  ];

  services.minecraft = {
    enable = true;
    whitelist = [
      {
        uuid = "45821aee-c1f4-4a47-af23-6e2983f37ce6";
        name = "DragonKing337";
      }
      {
        uuid = "a6578f9a-288d-44af-8f43-e6402b126bb6";
        name = "DarkKirb";
      }
    ];
  };
}
