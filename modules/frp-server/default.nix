{ lib, config, pkgs, ... }:
{

  imports = [ ./frp-port-keeper.nix ];

  # Allow some ports
  # TODO: Find a way to pass a range of ports as oppposed to integers
  # networking.firewall.allowedTCPPorts = [ 7000 7500 8000 ];
  # FIXME: Disabling firewall until I find a solution to pass ranges
  # of ports to allow
  networking.firewall.enable = false;

  services.frp = {
    enable = true;
    role = "server";
    settings = {
      common = {
        bind_addr = "0.0.0.0";
        bind_port = 7000;
        authentication_method = "token";
        # FIXME: Find a way to pass the token via a secret
        token = "Aloha, LibrePod!";
        allow_ports = "8000-50000";
        # Admin UI
        dashboard_port = 7500;
        dashboard_user = "librepod";
        # FIXME: Find a way to pass the dashboard password via a secret
        dashboard_pwd = "its-really-awesome9";
      };
      "plugin.frp-port-keeper" = {
        addr = "127.0.0.1:8080";
        path = "/port-registrations";
        ops = "NewProxy";
      };
    };
  };
}
