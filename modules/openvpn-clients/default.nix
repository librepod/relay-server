{ config, ... }:
{
  config = {
    sops.secrets = {
      "tiger-dev.ovpn" = {
        format = "binary";
        sopsFile = ../../secrets/tiger-dev.ovpn;
        mode = "0777";
      };
      "tiger-prod.ovpn" = {
        format = "binary";
        sopsFile = ../../secrets/tiger-prod.ovpn;
        mode = "0777";
      };
      "chicken.ovpn" = {
        format = "binary";
        sopsFile = ../../secrets/chicken.ovpn;
        mode = "0777";
      };
      "chicken.ovpn.pass" = {
        format = "binary";
        sopsFile = ../../secrets/chicken.ovpn.pass;
        mode = "0777";
      };
    };

    services.openvpn.servers = {
      # To view connection status use: systemctl status openvpn-tiger.service
      tiger-dev  = {
        config = ''
          config ${config.sops.secrets."tiger-dev.ovpn".path}
        '';
        updateResolvConf = true;
        autoStart = false;
      };
      tiger-prod  = {
        config = ''
          config ${config.sops.secrets."tiger-prod.ovpn".path}
        '';
        updateResolvConf = true;
        autoStart = false;
      };
      chicken  = {
        config = ''
          config ${config.sops.secrets."chicken.ovpn".path}
          auth-user-pass ${config.sops.secrets."chicken.ovpn.pass".path}
        '';
        updateResolvConf = true;
        autoStart = false;
      };
    };
  };
}
