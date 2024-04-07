{ config, ... }:
{
  config = {
    sops.secrets = {
      "tiger.ovpn" = {
        format = "binary";
        sopsFile = ../../secrets/tiger.ovpn;
        mode = "0777";
      };
      "panda.ovpn" = {
        format = "binary";
        sopsFile = ../../secrets/panda.ovpn;
        mode = "0777";
      };
    };

    # Establish connections to OVPN servers
    # To view connection status use:
    # systemctl status openvpn-ru-konsol.service
    services.openvpn.servers = {
      konsol-pro-ru  = {
        config = ''
          config ${config.sops.secrets."panda.ovpn".path}
        '';
        updateResolvConf = true;
        autoStart = false;
      };
      tigersender  = {
        config = ''
          config ${config.sops.secrets."tiger.ovpn".path}
        '';
        updateResolvConf = true;
        autoStart = false;
      };
    };
  };
}
