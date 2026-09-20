# NixOS Configuration

My NixOS system configuration. This repo covers the **system** (packages, services, users, boot, etc.).

User-level config files that live in `$HOME` are kept in a separate repo: [AbubakrBardien/dotfiles](https://github.com/AbubakrBardien/dotfiles).

| Repo | Purpose | Lives at |
|------|---------|----------|
| This repo | System configuration (`configuration.nix`) | `/etc/nixos` |
| Dotfiles repo | Config files in `$HOME` | `~/dotfiles` |

---

## Fresh Install

Boot the NixOS installer ISO and get online first (`nmtui` for Wi-Fi, or plug in Ethernet). Then work as root:

```sh
sudo -i
```

### Partition The Disk

Find your disk:

```sh
lsblk
```

Set it once so the rest of the commands are copy-pasteable. Use `/dev/sda` for SATA or `/dev/nvme0n1` for NVMe:

```sh
DISK=/dev/sda
```

> **Warning:** this wipes everything on `$DISK`.

Run `cfdisk`:

```sh
cfdisk $DISK
```

If it asks for a label type, choose **gpt**. Delete any existing partitions, then create these in order, using the following method:

Select "Free space" --> **New** --> Enter the size --> Press "Enter" --> Navigate to **Type** --> Select the type from the list.

| # | Size | Type (use **Type**) | Purpose |
|---|------|---------------------|---------|
| 1 | 1G | EFI System | Boot (ESP) |
| 2 | Rest of disk | Linux filesystem | Root |

Once that's done, choose **Write**, type `yes`, then **Quit**.

#### Format The Partitions

NVMe disks name partitions `p1`, `p2` instead of `1`, `2`:

```sh
mkfs.fat -F 32 -n boot ${DISK}1
mkfs.ext4 -L nixos ${DISK}2
```

#### Mount The Partitions

```sh
mount ${DISK}2 /mnt
mount --mkdir -o umask=077 ${DISK}1 /mnt/boot
```

### Generate The Configuration Files

This detects the machine's filesystems, kernel modules, etc. and writes `hardware-configuration.nix` and `configuration.nix`:

```sh
nixos-generate-config --root /mnt
```

Keep a copy of the generated hardware config; the next steps replace `/mnt/etc/nixos` with this repo.

```sh
cp /mnt/etc/nixos/hardware-configuration.nix /tmp/
```

### Load This Configuration

The installer doesn't ship with git, so open a shell that has it:

```sh
nix-shell -p git
```

Replace the generated `/mnt/etc/nixos` with this repo, then put the hardware config back:

```sh
rm -r /mnt/etc/nixos
git clone https://github.com/AbubakrBardien/nixos-config.git /mnt/etc/nixos
cp /tmp/hardware-configuration.nix /mnt/etc/nixos/
```

Review `/mnt/etc/nixos/configuration.nix` and make sure it imports `./hardware-configuration.nix` and that any machine-specific values (hostname, username, bootloader, disk labels) match this machine.

> If this repo tracks `hardware-configuration.nix`, the copy above will show up as a modification. Leave it for now and commit it after the first boot, once your git identity and credentials are set up.

### Install

```sh
nixos-install
```

`nixos-install` prompts for the **root** password at the end. Then set a normal user password before rebooting:

```sh
nixos-enter --root /mnt -c 'passwd <username>'
```

Then reboot and remove the installation media:

```sh
reboot
```

---

## After The First Boot

Log in as your user, then:

### Make `/etc/nixos` usable as your user

`/etc/nixos` is owned by root, which makes git complain about "dubious ownership" when run as a normal user. So we need to change the ownership of that directory:

```sh
sudo chown -R $USER:users /etc/nixos
```

### Clone The Dotfiles Repo

The dotfiles repo tracks `~/.config/git/config` (identity and credential helper), so cloning it also sets up git. The PAT is the one thing it can't contain: it lives in `~/.config/git/credentials` (not version controlled) and is saved automatically the first time git asks for it.

```sh
git clone https://github.com/AbubakrBardien/dotfiles.git ~/dotfiles
```

The repo is public, so git won't prompt you for a username and PAT, and no credentials are saved yet.
The first push to a repo will prompt for your username and PAT instead.
Then follow the instructions in that repo's README to setup your `$HOME` configuration.

---

## Day-to-day usage

Edit the config, then rebuild:

```sh
cd /etc/nixos
sudo nixos-rebuild switch
```

Useful variations:

| Command | What it does |
|---------|--------------|
| `sudo nixos-rebuild test` | Apply the config without making it the boot default |
| `sudo nixos-rebuild boot` | Apply on next boot only |
| `sudo nixos-rebuild switch --rollback` | Go back to the previous generation |
| `sudo nix-collect-garbage -d` | Delete old generations and free disk space |
