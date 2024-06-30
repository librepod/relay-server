# NOTE: This is just a copy-paste of the original module located here:
# https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/networking/frp.nix
# The only difference is the `ExecStart` line where we pass our own config
# with sensitive values generated from sops secrets

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.frp;
  settingsFormat = pkgs.formats.toml { };
  # configFile = settingsFormat.generate "frp.toml" cfg.settings;
  configFile = config.sops.secrets."frps-config.toml".path;
  isClient = (cfg.role == "client");
  isServer = (cfg.role == "server");
in
{
  options = {
    services.frp = {
      enable = mkEnableOption "frp";

      package = mkPackageOption pkgs "frp" { };

      role = mkOption {
        type = types.enum [ "server" "client" ];
        description = ''
          The frp consists of `client` and `server`. The server is usually
          deployed on the machine with a public IP address, and
          the client is usually deployed on the machine
          where the Intranet service to be penetrated resides.
        '';
      };

      settings = mkOption {
        type = settingsFormat.type;
        default = { };
        description = ''
          Frp configuration, for configuration options
          see the example of [client](https://github.com/fatedier/frp/blob/dev/conf/frpc_full_example.toml)
          or [server](https://github.com/fatedier/frp/blob/dev/conf/frps_full_example.toml) on github.
        '';
        example = {
            serverAddr = "x.x.x.x";
            serverPort = 7000;
          };
      };
    };
  };

  config =
    let
      serviceCapability = optionals isServer [ "CAP_NET_BIND_SERVICE" ];
      executableFile = if isClient then "frpc" else "frps";
    in
    mkIf cfg.enable {
      systemd.services = {
        frp = {
          wants = optionals isClient [ "network-online.target" ];
          after = if isClient then [ "network-online.target" ] else [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          description = "A fast reverse proxy frp ${cfg.role}";
          serviceConfig = {
            Type = "simple";
            Restart = "on-failure";
            RestartSec = 15;
            # NOTE: I tried passing --dashboard-pwd and --token here to
            # augment the default config file but it seems that frps ignores those
            # parameters if the actual config is passed via the --config param.
            ExecStart = "${cfg.package}/bin/${executableFile} --strict_config -c ${configFile}";
            StateDirectoryMode = optionalString isServer "0700";
            DynamicUser = true;
            # Hardening
            UMask = optionalString isServer "0007";
            CapabilityBoundingSet = serviceCapability;
            AmbientCapabilities = serviceCapability;
            PrivateDevices = true;
            ProtectHostname = true;
            ProtectClock = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectKernelLogs = true;
            ProtectControlGroups = true;
            RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ] ++ optionals isClient [ "AF_UNIX" ];
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            PrivateMounts = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [ "@system-service" ];
          };
        };
      };
    };

  meta.maintainers = with maintainers; [ zaldnoay ];
}
