# Dotfiles & NixOS Configuration

Unified configuration repository for system configuration (NixOS) and desktop dotfiles.

## System Overview

- **Host**: `v-nix`
- **OS**: NixOS Unstable / 25.11
- **Hardware**:
  - **CPU**: AMD Ryzen 7 5700X (8C/16T)
  - **GPU**: NVIDIA GeForce RTX 4070 (Gigabyte Windforce OC 12GB)
  - **Motherboard**: Gigabyte B550I AORUS PRO AX
  - **Storage**:
    - SATA SSD (`/dev/sda2`): Btrfs root filesystem
    - NVMe SSD (`/dev/nvme0n1p2`): `/home/voil/disks/wdb` (Games & Media)
- **Desktop Environment**:
  - **Compositor**: Hyprland (configured with `hyprland.lua`)
  - **Bar**: Waybar
  - **Launcher & Cliphist**: Rofi
  - **Notifications**: SwayNC
  - **Shell**: Fish
  - **Terminal**: Kitty
  - **File Manager**: Yazi
  - **Audio Engine**: PipeWire + Carla headless rack (`t732.carxp`, `carla-mic.service`)

---

## Repository Structure

```
~/dotfiles/
├── bin/                    # User scripts symlinked to ~/.local/bin/
│   ├── carla-mic-routing.sh
│   ├── davinci-run.sh
│   ├── mindustry
│   └── start-davinci.sh
├── config/                 # Dotfiles symlinked to ~/.config/
│   ├── btop/
│   ├── carla/
│   ├── fastfetch/
│   ├── fish/
│   ├── gtk-3.0/
│   ├── gtk-4.0/
│   ├── hypr/
│   ├── imv/
│   ├── kitty/
│   ├── mpv/
│   ├── nvim/
│   ├── qt5ct/
│   ├── qt6ct/
│   ├── rofi/
│   ├── swaync/
│   ├── systemd/user/
│   ├── waybar/
│   ├── wiremix/
│   └── yazi/
├── nixos/                  # Declarative NixOS configuration (Flake)
│   ├── bin/                # Firmware and binary blobs (e.g. patched_edid.bin)
│   ├── secrets/            # Unversioned secrets (ignored in git)
│   │   └── password-hash
│   ├── soft/               # Packages and custom modules
│   │   ├── custom/
│   │   │   ├── kernel.nix
│   │   │   ├── replay.nix # OBS Shadowplay buffer service
│   │   │   └── obs/
│   │   └── packages.nix
│   ├── configuration.nix
│   ├── desktop.nix
│   ├── dotfiles.nix        # Declarative user symlink management (systemd.tmpfiles)
│   ├── flake.lock
│   ├── flake.nix
│   ├── greeter.nix
│   ├── hardware-configuration.nix
│   └── users.nix
└── README.md
```

---

## Installation & Deployment

### 1. Linking Dotfiles and NixOS Config
All dotfiles and user scripts are managed natively and declaratively through NixOS using `systemd.tmpfiles.rules` defined in `nixos/dotfiles.nix`.

No external deployment scripts are needed. To apply or update symlinks, simply rebuild the system:

```bash
sudo nixos-rebuild switch
```

Systemd will automatically verify, create, and maintain all symlinks in `~/.config/` and `~/.local/bin/`.

### 2. NixOS Secrets Setup (Fresh Install)
Password hashes and sensitive keys are kept out of version control and `/nix/store`:

```bash
mkdir -p ~/dotfiles/nixos/secrets
chmod 700 ~/dotfiles/nixos/secrets
mkpasswd -m sha-512 > ~/dotfiles/nixos/secrets/password-hash
chmod 600 ~/dotfiles/nixos/secrets/password-hash
```

### 3. Rebuilding System
Because the repository uses Nix Flakes, any new or modified files in `nixos/` must be staged in Git (`git add .`) before rebuilding:

```bash
sudo nixos-rebuild switch --flake ~/dotfiles/nixos#v-nix
```

Or simply (since `/etc/nixos` is symlinked):

```bash
sudo nixos-rebuild switch
```
