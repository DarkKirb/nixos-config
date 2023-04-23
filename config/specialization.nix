# Configuration file configuring specialization
{config, ...}: {
  environment.etc."nix/local-system.json".text = builtins.toJSON {
    inherit (config.nixpkgs.localSystem) system gcc rustc linux-kernel;
  };

  # Instead of overriding stdenv, we provide a user hook that appends the correct configure flags
  nixpkgs.config.stdenv.userHook = ''
    NIX_CFLAGS_COMPILE+="-O3 -pipe -flto"
    unset doCheck doInstallCheck
  '';
}
