{ config, pkgs, hyprland, ... }:

{
  # Theme & Display Configuration
  environment.sessionVariables = {
    GTK_THEME = "adw-gtk3-dark";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "21";
    HYPRSHOT_DIR = "/tmp";
  };

  # Qt Configuration
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  # Sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;

    extraConfig.pipewire."99-virtual-mic" = {
      "context.objects" = [
        {
          factory = "adapter";
          args = {
            "factory.name"     = "support.null-audio-sink";
            "node.name"        = "virtual_mic";
            "node.description" = "Virtual Mic";
            "media.class"      = "Audio/Source/Virtual";
            "audio.position"   = [ "FL" "FR" ];
            "object.linger"    = true;
            "monitor.channel-volumes" = true;
          };
        }
      ];
    };
  };

  # WM
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.dconf.enable = true;

  # Fonts Packages
  fonts.packages = with pkgs; [
    meslo-lg
    nerd-fonts.symbols-only
  ];
}
