{ self, deploy, ... }:
let
  mkRelayHost = server: ip: {
    hostname = "${ip}:22";
    profiles.system.path =
      deploy.lib.x86_64-linux.activate.nixos
        self.nixosConfigurations."${server}";
  };
in
{
  user = "root";
  sshUser = "root";
  nodes = {
    ru = mkRelayHost "ru" "ru.relay.librepod.org";
    kz = mkRelayHost "kz" "kz.relay.librepod.org";
    ee  = mkRelayHost "ee" "ee.relay.librepod.org";
  };
}
