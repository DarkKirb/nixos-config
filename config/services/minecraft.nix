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
    paper-yml = {
      world-settings.default = {
        max-auto-save-chunks-per-tick = 8;
        optimize-explosions = true;
        mob-spawner-tick-rate = 2;
        game-mechanics.disable-chest-cat-detection = true;
        container-update-tick-rate = 3;
        max-entity-collisions = 2;
        grass-spread-tick-rate = 4;
        non-player-arrow-despawn-rate = 60;
        creative-arrow-despawn-rate = 60;
        despawn-ranges = rec {
          monster = {
            soft = 28;
            hard = 96;
          };
          creature = monster;
          ambient = monster;
          axolotls = monster;
          underground_water_creature = monster;
          water_creature = monster;
          water_ambient = {
            soft = 28;
            hard = 32;
          };
          misc = monster;
        };
        hopper = {
          disable-move-event = true;
        };
        prevent-moving-into-unloaded-chunks = true;
        use-faster-eigencraft-redstone = true;
        armor-stands-tick = false;
        per-player-mob-spawns = true;
      };
    };
  };
}
