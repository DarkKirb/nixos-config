{ config, pkgs, lib, ... }: {
  environment.extraInit =
    let
      systemdBin = lib.getBin config.systemd.package;
    in
    ''
      set -a
      . /dev/fd/0 <<EOF
        $(${systemdBin}/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
      EOF
      set +a
    '';
}
