{ lib, ... }:
{
  imports = [
    ../../modules/disko/cloud1-ru.nix
    ../../modules/base
    # ../../modules/frp-server
    ../../modules/xray-server
  ];

  # Some of the hosters' VMs can not mount a disk by a lable that disko
  # provides. In such cases we have to find out the UUID of the disk once the
  # VM is created and paste it here.
  disko.devices.disk.main.device = lib.mkForce "/dev/disk/by-uuid/d7ca195e-7879-4169-85bb-58237c1476e8";

  system.stateVersion = "23.11";
}
