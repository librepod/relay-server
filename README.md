# Setup instructions

Once you have your server up and running, copy your ssh public key to it
for passwordless access via ssh. This is needed for ansible to connect to it.
```sh
ssh-copy-id root@<host>

```
