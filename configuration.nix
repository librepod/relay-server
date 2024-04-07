{ config, lib, inputs, ... }:
let
  device = lib.strings.fileContents ./device.txt;
in
{
  imports = [
    (./. + "/hosts/${hos}")
  ];

  # based on this awesome tutorial: https://www.youtube.com/watch?v=G5f6GC7SnhU
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/alex/.config/sops/age/keys.txt";

    # secrets.hello = { };
    secrets."xray-config.json" = {
      format = "binary";
      sopsFile = ./secrets/xray-config.json;
      mode = "0777";
    };
  };

}
