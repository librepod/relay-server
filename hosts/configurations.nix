{ self , nixpkgs , sops-nix , inputs , ... }:
let
  nixosSystem = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem;
  # customModules = import ../modules/modules-list.nix;
  customModules = [ ];
  baseModules = [
    {
      imports = [
        ../modules/nix
        sops-nix.nixosModules.sops
      ];
    }
  ];
  defaultModules = baseModules ++ customModules;
in
{
  ru = nixosSystem {
    system = "x86_64-linux";
    modules = defaultModules ++ [
      ./ru/default.nix
    ];
    specialArgs = { inherit inputs; };
  };
}
