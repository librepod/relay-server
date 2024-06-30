{ config, ... }:
{
  # This is just a dummy frps.ini config file with known path. It's only
  # purpose is to pass `allow_ports` param to frp-port-keeper plugin.
  environment.etc."frps.ini".text = ''
[common]
allow_ports = "8000-50000";
  '';

  virtualisation.oci-containers.containers.frp-port-keeper = {
    image = "ghcr.io/librepod/frp-port-keeper:v0.2.1";
    volumes = [
      "/etc/frps.ini:/app/frps.ini"
      "frp_port_keeper_data:/app/gokv"
    ];
    ports = [
      "8080:8080"
    ];
    autoStart = true;
  };
}
