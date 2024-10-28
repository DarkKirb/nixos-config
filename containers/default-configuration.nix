{system, ...}: {
  inherit system;
  config = import ./default.nix;
  autoStart = true;
}
