λ(host: Text) →

--  TODO: Deduplicate with the nix code

{
  -- Common config
  caddyConfig = {
    admin = {
      disabled = True
    },
    storage = {
      module = "file_system",
      root = "/var/lib/caddy"
    },
    apps = {
      http = ./http.dhall host
    }
  },
  nixosConfig = {
    systemd = {
      tmpfiles = {
        rules = [
          "d '/var/lib/caddy' 0750 caddy acme - -"
        ]
      }
    },
    networking = {
      firewall = {
        allowedTCPPorts = [ 80, 443 ],
        allowedUDPPorts = [ 443 ]
      }
    },
    security = {
      acme = {
        certs = let value = { reloadServices = ["caddy.service"] } in {
          `darkkirb.de` = value,
          `chir.rs` = value,
          `int.chir.rs` = value,
          `miifox.net` = value
        }
      }
    }
  }
}
