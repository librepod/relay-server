{ config, ... }:
{
  environment.etc."frps.ini".text = ''
[common]
allow_ports = ${config.services.frp.settings.common.allow_ports}
  '';

  virtualisation.oci-containers.containers.frp-port-keeper = {
    image = "ghcr.io/librepod/frp-port-keeper:v0.2.1";
    # TODO: Add folume for key/val storage
    volumes = [
      "/etc/frps.ini:/app/frps.ini"
    ];
    ports = [
      "8080:8080"
    ];
    autoStart = true;
  };
}
