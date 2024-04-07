{ config, pkgs, ... }:
{
  config = {
    sops.secrets."xray-server-config.json" = {
      format = "binary";
      sopsFile = ../../secrets/xray-server-config.json;
      mode = "0777";
    };

    networking.firewall.allowedTCPPorts = [ 10086 ];

    environment.systemPackages = [
      pkgs.v2ray-domain-list-community
      pkgs.v2ray-geoip
    ];

    services.xray = {
      enable = true;
      # See examples here: https://github.com/XTLS/Xray-examples/tree/main
      settingsFile = config.sops.secrets."xray-server-config.json".path;
    };
  };
}
