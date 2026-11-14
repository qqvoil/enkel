{ config, pkgs, ... }:

{
  # Enable hyprlock with PAM authentication
  programs.hyprlock.enable = true;

  # Fast direct boot into Hyprland (locked with hyprlock on startup)
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "start-hyprland";
        user = "voil";
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
        user = "greeter";
      };
    };
  };
}
