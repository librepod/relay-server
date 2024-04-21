{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.sops-nix.url = "github:mic92/sops-nix";
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.deploy-rs.url = "github:serokell/deploy-rs";

  outputs = { self, nixpkgs, disko, sops-nix, deploy-rs, ... }: {
    # This server was provisioned manually. NixOS was installed manually, then
    # tweaked a bit in order to be available via ssh, then deploy_rs did the
    # trick.
    nixosConfigurations.kz = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        sops-nix.nixosModules.sops
        ./hosts/kz_pqhosting
      ];
    };
    # This server was installed by nixos-anywhere.
    # nixosConfigurations.ru = nixpkgs.lib.nixosSystem {
    #   system = "x86_64-linux";
    #   modules = [
    #     disko.nixosModules.disko
    #     sops-nix.nixosModules.sops
    #     ./hosts/ru
    #   ];
    # };
    deploy.nodes = {
      kz = {
        hostname = "kz2.relay.librepod.org";
        profiles.system = {
          user = "root";
          sshUser = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.kz;
        };
      };
      # ru = {
      #   hostname = "ru.relay.librepod.org";
      #   profiles.system = {
      #     user = "root";
      #     sshUser = "root";
      #     path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.ru;
      #   };
      # };
    };
    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
