{
  lib,
  ...
}:
{
  xdg.configFile."kwinoutputconfig.json".text = lib.strings.toJSON [
    {
      data = [
        {
          brightness = 0.8;
          connectorName = "DSI-1";
          mode = {
            height = 1280;
            refreshRate = 60000;
            width = 480;
          };
          scale = 0.9;
          transform = "Rotated270";
        }
      ];
      name = "outputs";
    }
    {
      data = [
        {
          lidClosed = false;
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
          ];
        }
      ];
      name = "setups";
    }
  ];
}
