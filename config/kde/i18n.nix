{...}: {
  services.libinput.enable = true;
  services.xserver.xkb = {
    layout = "de";
    variant = "neo";
  };
}
