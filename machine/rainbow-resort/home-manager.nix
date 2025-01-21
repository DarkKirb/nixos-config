{ lib, nixos-config, ... }:
{
  imports = [ "${nixos-config}/services/desktop/plover.nix" ];
  xdg.configFile."kwinoutputconfig.json".text = lib.strings.toJSON [
    {
      data = [
        {
          brightness = 1;
          connectorName = "DP-2";
          mode = {
            height = 1440;
            refreshRate = 74971;
            width = 2560;
          };
          scale = 1;
          vrrPolicy = "Always";
          edidHash = "629828d7adf0784d54d0fab41f79d710";
          edidIdentifier = "LEN 26280 0 1 2021 0";
        }
        {
          brightness = 1;
          connectorName = "HDMI-A-1";
          edidHash = "b7c9a7401fcf59c40219386d623919c8";
          edidIdentifier = "BNQ 30881 21573 49 2016 0";
        }
      ];
      name = "outputs";
    }
    {
      data = [
        {
          outputs = [
            {
              enabled = true;
              outputIndex = 0;
              position = {
                x = 0;
                y = 0;
              };
              priority = 0;
            }
            {
              enabled = true;
              outputIndex = 1;
              position = {
                x = 2560;
                y = 547;
              };
              priority = 1;
            }
          ];
        }
      ];
      name = "setups";
    }
  ];
}
