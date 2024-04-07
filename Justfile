morph-deploy host:
  morph deploy ./deploy.nix switch --on {{host}}

morph-build-dry-run host:
  morph build ./deploy.nix --dry-run --on {{host}}
  # earthly +morphBuildDryRun

# Decrypt sops binary secret
@decrypt-binary file:
  sops --decrypt --output-type binary --in-place {{file}}
# Ecrypt sops binary secret
@encrypt-binary file:
  sops --encrypt --input-type binary --in-place {{file}}
