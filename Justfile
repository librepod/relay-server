@prepare-secret file:
  cp ./secrets/raw.{{file}} ./secrets/{{file}}
  just encrypt-binary ./secrets/{{file}}

@prepare-secrets:
  just prepare-secret chicken-auth.txt
  just prepare-secret chicken.ovpn
  just prepare-secret frps-config.toml
  just prepare-secret tiger-dev.ovpn
  just prepare-secret tiger-prod.ovpn
  just prepare-secret xray-server-config.json

# Decrypt sops binary secret
@decrypt-binary file:
  sops --decrypt --output-type binary --in-place {{file}}
# Encrypt sops binary secret
@encrypt-binary file:
  sops --encrypt --input-type binary --in-place {{file}}

deploy host: prepare-secrets
  deploy ./#{{host}}
