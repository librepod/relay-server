let
  pkgs = import (builtins.fetchGit {
    name = "nixos-23.11";
    url = "https://github.com/nixos/nixpkgs";
    # Commit hash for tag 23.11
    # `git ls-remote https://github.com/nixos/nixpkgs 23.11`
    ref = "refs/tags/23.11";
    rev = "7c6e3666e2040fb64d43b209b84f65898ea3095d";
  }) {};
in
{
  network =  {
    inherit pkgs;
    description = "LibrePod Relay Servers";
    ordering = {
      tags = [ "relays" ];
    };
  };

  ru_relay = { config, pkgs, lib, ... }:
  let
    hostAddress = "ru.relay.librepod.org";
  in {
    imports = [ (import ./hosts/ru_relay { inherit config lib pkgs; }) ];
    deployment = {
      tags = [ "relays" ];
      targetHost = hostAddress;
      targetUser = "root";
    };
  };
}
