{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # VST variables
  environment.variables = {
    VST_PATH = "/run/current-system/sw/lib/vst:~/.vst";
    VST3_PATH = "/run/current-system/sw/lib/vst3:~/.vst3";
    LV2_PATH = "/run/current-system/sw/lib/lv2:~/.lv2";
    LADSPA_PATH = "/run/current-system/sw/lib/ladspa:~/.ladspa";
  };

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extest.enable = true;
  };

  # Obs
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };
  };

  # Throne
  programs.throne.enable = true;
  programs.throne.tunMode.enable = true;
  
  environment.systemPackages = with pkgs; [
    kicad
    clang
    rustc
    traceroute
    iperf3
    antimicrox
    mlv-app
    discord
    s-tui
    kitty
    fastfetch
    curl
    neovim
    btop
    p7zip
    hyprpaper
    grimblast
    waybar
    rofi
    cliphist
    wl-clipboard
    python3
    telegram-desktop
    spotify
    reaper
    neural-amp-modeler-lv2
    git
    sbctl
    rsync
    sing-box
    yazi
    libsForQt5.qt5ct
    kdePackages.qt6ct
    adw-gtk3
    adwaita-qt
    adwaita-qt6
    glib
    gsettings-desktop-schemas
    gnome-themes-extra
    sshs
    adwaita-icon-theme
    bibata-cursors
    mpv
    imv
    parted
    ntfs3g
    qpwgraph
    carla
    lsp-plugins
    calf
    speedtest-cli
    x42-plugins
    zam-plugins
    artyFX
    synthv1
    samplv1
    drumkv1
    padthv1
    distrho-ports
    wiremix
    libGLU
    antigravity-ide
    antigravity-cli
    wayvnc
    swaynotificationcenter
    playerctl
    prismlauncher
    distrobox
    zen-browser
    droidcam
    libimobiledevice
    lm_sensors
  ];
}
