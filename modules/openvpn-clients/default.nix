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

    services.openvpn.servers = {
      # To view connection status use: systemctl status openvpn-panda.service
      panda  = {
        config = ''
          config ${config.sops.secrets."panda.ovpn".path}
        '';
        updateResolvConf = true;
        autoStart = false;
      };
      # To view connection status use: systemctl status openvpn-tiger.service
      tiger  = {
        config = ''
          config ${config.sops.secrets."tiger.ovpn".path}
        '';
        updateResolvConf = true;
        autoStart = false;
      };
    };
  };
}
