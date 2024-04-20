{ config, lib, pkgs, ... }@args:
{
  imports = [
    ./configuration.nix
    ../../modules/base
    # ./disko.nix
    # ../../modules/frp-server
    # ../../modules/xray-server
    # ../../modules/openvpn-clients
  ];
  # based on this awesome tutorial: https://www.youtube.com/watch?v=G5f6GC7SnhU
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    # This will automatically import remote host SSH keys as age keys
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets.hello = { };
    # secrets."xray-server-config.json" = {
    #   format = "binary";
    #   sopsFile = ../../secrets/xray-server-config.json;
    #   mode = "0777";
    # };
    # secrets."tigersender.ovpn" = {
    #   format = "binary";
    #   sopsFile = ../../secrets/tigersender.ovpn;
    #   mode = "0777";
    # };
    # secrets."konsolpro.ovpn" = {
    #   format = "binary";
    #   sopsFile = ../../secrets/konsolpro.ovpn;
    #   mode = "0777";
    # };
  };
}
