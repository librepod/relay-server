# Example to create a bios compatible gpt partition
{ lib, ... }:
{
  # For cloud.ru VMs we are using MBR
  boot.loader.grub = {
    # No need to set devices, disko will add all devices that have a EF02
    # partition to the list already
    # devices = [ ];
    efiSupport = false;
    efiInstallAsRemovable = false;
  };

  disko.devices = {
    disk = {
      vda = {
        device = lib.mkDefault "/dev/vda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1G";
              type = "EF02"; # for grub MBR
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
