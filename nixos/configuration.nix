{ config, lib, pkgs, hyprland, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./users.nix
    ./desktop.nix
    ./greeter.nix
    ./dotfiles.nix
    ./soft/packages.nix
    ./soft/custom/kernel.nix
    ./soft/custom/replay.nix
  ];

  # Nix settings and Garbage Collection
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Boot (Clean native systemd-boot with sbctl Secure Boot integration)
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.timeout = 5;

  boot.loader.systemd-boot.extraInstallCommands = ''
    export PATH="${pkgs.coreutils}/bin:${pkgs.findutils}/bin:${pkgs.util-linux}/bin:${pkgs.rsync}/bin:${pkgs.sbctl}/bin:$PATH"

    # 1. Sign systemd-boot binaries (NVRAM target & Removable Fallback)
    mkdir -p /efi/EFI/systemd
    if [ -f /efi/EFI/BOOT/BOOTX64.EFI ]; then
      cp -u /efi/EFI/BOOT/BOOTX64.EFI /efi/EFI/systemd/systemd-bootx64.efi 2>/dev/null || true
    fi
    if [ -f /efi/EFI/systemd/systemd-bootx64.efi ]; then
      sbctl sign -s /efi/EFI/systemd/systemd-bootx64.efi || true
    fi
    if [ -f /efi/EFI/BOOT/BOOTX64.EFI ]; then
      sbctl sign -s /efi/EFI/BOOT/BOOTX64.EFI || true
    fi

    # 2. Sign all NixOS kernel images (specifically *-bzImage.efi or kernel-*.efi, ignoring initrd)
    find /efi/EFI/nixos/ -type f \( -name "*-bzImage.efi" -o -name "kernel-*.efi" \) 2>/dev/null | while read -r file; do
      sbctl sign -s "$file" || true
    done

    # 3. Sync Windows Boot Manager from sda3 to /efi so systemd-boot displays it
    mkdir -p /run/win-efi
    if mount -o ro /dev/disk/by-uuid/8E32-23D7 /run/win-efi 2>/dev/null; then
      if [ -d /run/win-efi/EFI/Microsoft ]; then
        rsync -a --delete /run/win-efi/EFI/Microsoft/ /efi/EFI/Microsoft/
      fi
      umount /run/win-efi
    fi
  '';

  # Sync Windows Boot Manager to Linux ESP on boot
  systemd.services.sync-windows-boot = {
    description = "Sync Windows Boot Manager to Linux ESP";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "sync-windows-boot" ''
        mkdir -p /run/win-efi
        if mount -o ro /dev/disk/by-uuid/8E32-23D7 /run/win-efi 2>/dev/null; then
          if [ -d /run/win-efi/EFI/Microsoft ]; then
            ${pkgs.rsync}/bin/rsync -a --delete /run/win-efi/EFI/Microsoft/ /efi/EFI/Microsoft/
          fi
          umount /run/win-efi
        fi
      '';
    };
  };

  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelParams = [ "nvme_core.default_ps_max_latency_us=0" "pcie_aspm=off" "pcie_port_pm=off" "drm.edid_firmware=DP-3:edid/patched_edid.bin" ];
  boot.kernelModules = [ "xt_TPROXY" "xt_socket" "v4l2loopback" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
  };

  # Net
  networking.firewall.enable = false;
  networking.networkmanager.enable = false;
  networking.useDHCP = false;
  networking.hostName = "v-nix";
  
  systemd.network.enable = true;
  systemd.network.networks."static" = {
    matchConfig.Name = "eno1";
    address = [ "192.168.3.27/24" ];
    routes = [ { Gateway = "192.168.3.1"; } ];
    dns = [ "1.1.1.1" "8.8.8.8" ];
    linkConfig.RequiredForOnline = "routable";
    linkConfig.MTUBytes = "1500";
  };

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  
  # Swap

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/cfaa2aea-4e87-4e24-8c29-16a6de01579f";
    }
  ];

  # Video (Hardware)
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.firmware = [
  (pkgs.runCommand "patched-edid" {} ''
    mkdir -p $out/lib/firmware/edid
    cp ${./bin/patched_edid.bin} $out/lib/firmware/edid/patched_edid.bin
  '')
];

  # Bluetooth (Hardware)
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = { General = { Experimental = true; }; };
  };
  services.blueman.enable = true;

  # Security & Daemons
  security.rtkit.enable = true;
  programs.fish.enable = true;
  programs.nix-ld.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.openssh.enable = true;
  services.resolved.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.usbmuxd.enable = true;
  services.fstrim.enable = true;

  # Virtualisation
  virtualisation.podman.enable = true;
  hardware.nvidia-container-toolkit.enable = true;

  # Disks
  fileSystems."/home/voil/disks/wdb" = {
    device = "/dev/disk/by-label/wdb";
    fsType = "btrfs";
    options = [ "noatime" "nofail" ];
  };

  # Systemd shutdown timeouts (prevent 90s hung stop jobs)
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
  systemd.user.settings.Manager.DefaultTimeoutStopSec = "10s";

  # State
  system.stateVersion = "25.11";
}
