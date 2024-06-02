{
  imports = [
    ../../modules/disko/cloud1-ru.nix
    ../../modules/base
    # ../../modules/frp-server
    ../../modules/xray-server
  ];

  system.stateVersion = "23.11";
}
