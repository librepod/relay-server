{
  imports = [
    ../../modules/disko/cloud-ru.nix
    ../../modules/base
    ../../modules/frp-server
    ../../modules/xray-server
  ];

  system.stateVersion = "23.11";
}
