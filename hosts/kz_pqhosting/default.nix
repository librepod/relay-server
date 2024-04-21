{ config, lib, pkgs, ... }@args:
{
  imports = [
    ./configuration.nix
    ../../modules/base
    ../../modules/frp-server
    ../../modules/xray-server
  ];

  system.stateVersion = "23.11";
}
