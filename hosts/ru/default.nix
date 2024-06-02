{
  imports = [
    ../../modules/disko/cloud-ru-2.nix
    ../../modules/base
    ../../modules/frp-server
    ../../modules/xray-server
    ../../modules/openvpn-clients
  ];

  system.stateVersion = "23.11";
}
