{ system, ... }:
{
  inherit system;
  config = import ./postgresql.nix;
  autoStart = true;
  privateNetwork = true;
}
