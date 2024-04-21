{ modulesPath, lib, pkgs, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "sr_mod"
    "virtio_blk"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.loader.grub = {
    device = "/dev/vda";
    enable = true;
    useOSProber = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c68681a2-51bd-4764-a2a6-5507f5531845";
    fsType = "ext4";
  };
  swapDevices = [ ];

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking = {
    interfaces.ens3.useDHCP = false;
    interfaces.ens3.ipv4.addresses = [
      {
        address = "86.104.73.182";
        prefixLength = 24;
      }
    ];
    defaultGateway = {
      address = "86.104.73.1";
      interface = "ens3";
    };
  };
}
