{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.sops-nix.url = "github:mic92/sops-nix";
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.deploy-rs.url = "github:serokell/deploy-rs";

  outputs = { self, nixpkgs, disko, sops-nix, deploy-rs, ... }: {

    nixosConfigurations = {
      ru = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          ./hosts/ru
        ];
      };
      kz = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          ./hosts/kz_cloud1
        ];
      };
    };

    deploy.nodes = {
      kz = {
        hostname = "185.233.3.70";
        profiles.system = {
          user = "root";
          sshUser = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.kz;
        };
      };
      ru = {
        hostname = "ru.relay.librepod.org";
        profiles.system = {
          user = "root";
          sshUser = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.ru;
        };
      };
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
