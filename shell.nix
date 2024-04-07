{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShell {
  packages = with pkgs; [
    just
    morph
    sops
    deploy-rs
  ];
}
