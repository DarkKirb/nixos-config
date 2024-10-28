{
  config,
  lib,
  ...
}:
with lib; {
  options.networking = {
    rootHostName = mkOption {
      description = "Hostname of the running host";
      type = types.str;
      default = "";
      example = "rainbow-resort";
    };
    nodeID = mkOption {
      description = "Unique node ID";
      type = types.str;
      readOnly = true;
    };
    fullHostName = mkOption {
      description = "Full combined host name";
      type = types.str;
      readOnly = true;
    };
  };

  config = {
    networking = rec {
      fullHostName =
        if config.networking.rootHostName == ""
        then config.networking.hostName
        else "${config.networking.rootHostName}-${config.networking.hostName}";
      nodeID = lib.substring 0 8 (builtins.hashString "sha256" fullHostName);
    };
  };
}
