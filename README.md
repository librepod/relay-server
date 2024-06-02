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

## Secrets

## Install NixOS using [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) (preferably)

Bear in mind that with some hosting providers it is not possible to install
NixOS using this method, nevertheless its still worth to try.

### cloud.ru installation (**ru** relay example)

1. Spin up a new VM in cloud.ru. Make sure to give it at least 2Gb of RAM due
   to nixos-anywhere requirements. 
2. Make a keyscan of the newly created VM and update the __.sops.yaml__ file
   accordingly: `nix-shell -p ssh-to-age --run 'ssh-keyscan <VM_PUBLIC_IP> | ssh-to-age'`
3. Update all the secrets encryption keys like this: `sops updatekeys ./secrets.yaml`.
   Do this for all the files in ./secrets folder.
4. Install NixOS on the VM using nixos-anywhere:
```sh
nix run github:nix-community/nixos-anywhere -- --flake .#ru <VM_USER>@<VM_PUBLIC_IP>
5. Deploy nixos configuration to your newly server: `deploy ./#ru`
```

```sh
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

