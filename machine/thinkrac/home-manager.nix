{
  pkgs,
  lib,
  systemConfig,
  ...
}:
{
  xdg.configFile."kwinoutputconfig.json".text = lib.strings.toJSON [
    {
      data = [
        {
          brightness = 1;
          connectorName = "eDP-1";
          mode = {
            height = 1080;
            refreshRate = 60020;
            width = 1920;
          };
          scale = 1;
          edidHash = "a98f84335c22debdbdb73c8a000acb66";
          edidIdentifier = "LGD 1313 0 0 2016 0";
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
        {
          lidClosed = true;
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

  programs.vscode.extensions = with pkgs.vscode-extensions; [
    ms-vscode-remote.remote-ssh
  ];
}
// (
  if !systemConfig.isSway then
    {
      programs.plasma.configFile.kcminputrc."Libinput/2/7/SynPS\\/2 Synaptics TouchPad".DisableWhentyping =
        false;
    }
  else
    { }
)
