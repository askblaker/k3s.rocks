Multipass can be used to test the instructions.

It starts up a VM and runs through the instructions. Ideally this would be done in CI, but i'm waiting for github to support nested virtualization.

Install multipass with:

```bash
snap install multipass
```

Start the script with

```bash
./multipass.sh
```
