{ ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "ru-relay-librepod-org";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGis2Y/zwEDKbL4Os2tVs83hI1IXlL2hm7Ln0VJ/cI5q alex@carbon'' ];
  system.stateVersion = "23.11";
}
