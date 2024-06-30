{ lib, config, pkgs, ... }:
{

  # Disabling the default frp service in order to replace it with our own
  # slightly modified implementation with ability to use config from sops secrets.
  disabledModules = [ "services/networking/frp.nix" ];

  sops.secrets."frps-config.toml" = {
    format = "binary";
    sopsFile = ../../secrets/frps-config.toml;
    mode = "0777";
  };

  imports = [
    ./custom-frp.nix # since we are storing sensitive values in config
    ./frp-port-keeper.nix
  ];

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
      # Config is passed via sops secret and pointed to in our custom frp module.
    };
  };
}
