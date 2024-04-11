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
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
  boot.loader.grub = {
    # No need to set devices, disko will add all devices that have a EF02
    # partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
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

  system.stateVersion = "23.11";
}
