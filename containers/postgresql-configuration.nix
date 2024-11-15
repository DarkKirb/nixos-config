{ system, ... }:
{
  inherit system;
  config = import ./postgresql.nix;
  autoStart = true;
  privateNetwork = true;
  hostBridge = "containers";
  localAddress6 = "fdc6:e7e5:0ba1:1::2/64";
}
