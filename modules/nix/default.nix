{ config, pkgs, lib, ... }:

{
  boot.readOnlyNixStore = false;
  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "@wheel" ];
      allowed-users = [ "@wheel" ];
      experimental-features = [ "nix-command" "flakes" ];
      documentation.info.enable = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d --max-freed $((64 * 1024**3))";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };
}
