#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
BIN_DIR="$HOME/.local/bin"

echo "=== Deploying dotfiles from $REPO_DIR ==="

mkdir -p "$CONFIG_DIR" "$BIN_DIR"

# 1. Symlink ~/.config directories
echo "--- Linking configuration directories ---"
for item in "$REPO_DIR/config"/*; do
    [ -e "$item" ] || continue
    name="$(basename "$item")"

    if [ "$name" = "systemd" ]; then
        # Handle systemd user units individually to avoid overriding systemd state/wants
        mkdir -p "$CONFIG_DIR/systemd/user"
        for unit in "$item/user"/*; do
            [ -e "$unit" ] || continue
            uname="$(basename "$unit")"
            dest="$CONFIG_DIR/systemd/user/$uname"
            if [ -e "$dest" ] && [ ! -L "$dest" ]; then
                echo "Backing up existing $dest -> $dest.backup"
                mv "$dest" "$dest.backup"
            fi
            ln -sfn "$unit" "$dest"
            echo "Linked systemd unit: $uname -> $dest"
        done
        continue
    fi

    dest="$CONFIG_DIR/$name"

    if [ -L "$dest" ]; then
        target="$(readlink -f "$dest" 2>/dev/null || true)"
        if [ "$target" = "$item" ]; then
            echo "Already linked: $name"
            continue
        fi
        rm -f "$dest"
    elif [ -e "$dest" ]; then
        echo "Backing up existing $dest -> $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    ln -sfn "$item" "$dest"
    echo "Linked: $name -> $dest"
done

# 2. Symlink ~/.local/bin scripts
echo "--- Linking executable scripts ---"
for script in "$REPO_DIR/bin"/*; do
    [ -e "$script" ] || continue
    name="$(basename "$script")"
    dest="$BIN_DIR/$name"

    chmod +x "$script"

    if [ -L "$dest" ]; then
        target="$(readlink -f "$dest" 2>/dev/null || true)"
        if [ "$target" = "$script" ]; then
            echo "Already linked script: $name"
            continue
        fi
        rm -f "$dest"
    elif [ -e "$dest" ]; then
        echo "Backing up existing script $dest -> $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    ln -sfn "$script" "$dest"
    echo "Linked script: $name -> $dest"
done

# 3. Ensure NixOS secrets permissions
if [ -d "$REPO_DIR/nixos/secrets" ]; then
    chmod 700 "$REPO_DIR/nixos/secrets"
    if [ -f "$REPO_DIR/nixos/secrets/password-hash" ]; then
        chmod 600 "$REPO_DIR/nixos/secrets/password-hash"
    fi
fi

# 4. Check /etc/nixos symlink
echo "--- Checking /etc/nixos ---"
if [ -L "/etc/nixos" ]; then
    current_target="$(readlink -f /etc/nixos 2>/dev/null || true)"
    if [ "$current_target" = "$REPO_DIR/nixos" ]; then
        echo "/etc/nixos is already linked to $REPO_DIR/nixos."
    else
        echo "Updating /etc/nixos symlink..."
        sudo ln -sfn "$REPO_DIR/nixos" /etc/nixos
    fi
elif [ -d "/etc/nixos" ]; then
    echo "Backing up /etc/nixos to /etc/nixos.backup and linking $REPO_DIR/nixos..."
    sudo mv /etc/nixos /etc/nixos.backup
    sudo ln -sfn "$REPO_DIR/nixos" /etc/nixos
    echo "/etc/nixos successfully linked."
fi

echo "=== Dotfiles deployment completed successfully ==="
