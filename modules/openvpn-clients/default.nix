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
      "panda.ovpn" = {
        format = "binary";
        sopsFile = ../../secrets/panda.ovpn;
        mode = "0777";
      };
      "chicken.ovpn" = {
        format = "binary";
        sopsFile = ../../secrets/chicken.ovpn;
        mode = "0777";
      };
      "chicken-auth.txt" = {
        format = "binary";
        sopsFile = ../../secrets/chicken-auth.txt;
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
          auth-user-pass ${config.sops.secrets."chicken-auth.txt".path}
        '';
        updateResolvConf = true;
        autoStart = false;
      };
    };
  };
}
