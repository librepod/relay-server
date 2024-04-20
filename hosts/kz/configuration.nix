# { ... }: {
#   imports = [
#     ./hardware-configuration.nix
#   ];
#
#   boot.tmp.cleanOnBoot = true;
#   zramSwap.enable = true;
#   networking.hostName = "ru-relay-librepod-org";
#   networking.domain = "";
#   system.stateVersion = "23.11";
# }
{ modulesPath, lib, pkgs, ... }: {
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
    # No need to set devices, disko will add all devices that have a EF02
    # partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c68681a2-51bd-4764-a2a6-5507f5531845";
    fsType = "ext4";
  };
  swapDevices = [ ];

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGis2Y/zwEDKbL4Os2tVs83hI1IXlL2hm7Ln0VJ/cI5q alex@carbon"
  ];

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

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "23.11";
}
