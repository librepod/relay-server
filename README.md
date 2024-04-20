# Setup instructions

## Prerequisites
Once you have your server up and running, copy your ssh public key to `root` user's
authorized_keys file. This can be done manually from the remote machine like
this:
```sh
cat ~/.ssh/authorized_keys | sudo tee /root/.ssh/authorized_keys
```
or from your host machine in case you are allowed to connect to your VM as root user:
```sh
ssh-copy-id root@<host>
```
Make sure that you can connect to your VM without password using only SSH key.

## Install NixOS using [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) (preferably)

Bear in mind that with some hosting providers it is not possible to install
NixOS using this method, nevertheless its still worth to try.

```sh
nix-shell -p ssh-to-age --run 'ssh-keyscan <your_host> | ssh-to-age'
nix run github:nix-community/nixos-anywhere -- --flake .#kz --vm-test
nix run github:nix-community/nixos-anywhere -- --flake .#kz root@77.91.75.124
```

## Install NixOS using [nixos-infect script](https://github.com/elitak/nixos-infect):
 1. Ssh to your remote host preferably as the root user and execute sequentially:
  ```sh
  curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect -o nixos-infect
  chmod +x ./nixos-infect
  export NIX_CHANNEL=nixos-23.11
  # Use `sudo` with the command bellow only if your are connected under a different
  # user then `root`.
  ./nixos-infect
  ```
 2. Wait until setup is done. Then connect to your host again to make sure that
    it is still alive.
 3. Copy the generated configuration.nix and hardware-configuration.nix from the VM
    to the `hosts/<host>/` folder. Should be something like this:
    ```sh
    scp root@<host>:/etc/nixos/configuration.nix ./hosts/<relay_name>/`
    scp root@<host>:/etc/nixos/hardware-configuration.nix ./hosts/<relay_name>/`
    ```
 4. Update your VM with the code from this repo:
    ```sh
    just morph-deploy <relay_name>
    ```
nix-shell -p git --command "nix run github:librepod/relay-server/switch-to-nixos#kz --extra-experimental-features nix-command --extra-experimental-features flakes"
