{ config, pkgs, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # based on this awesome tutorial: https://www.youtube.com/watch?v=G5f6GC7SnhU
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    # This will automatically import remote host SSH keys as age keys
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets.hello = { };
  };

  services.openssh.enable = true;

  environment.variables = {
    EDITOR = "nvim";
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGis2Y/zwEDKbL4Os2tVs83hI1IXlL2hm7Ln0VJ/cI5q alex@carbon"
  ];

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
    '';
    promptInit = ""; # otherwise it'll override the grml prompt
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.dig
    pkgs.kitty
    pkgs.neovim
  ];
}
