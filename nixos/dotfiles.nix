{ ... }:

let
  user = "voil";
  homeDir = "/home/${user}";
  repoDir = "${homeDir}/dotfiles";

  linkConfig = name: "L+ ${homeDir}/.config/${name} - - - - ${repoDir}/config/${name}";
  linkBin = name: "L+ ${homeDir}/.local/bin/${name} - - - - ${repoDir}/bin/${name}";

  configDirs = [
    "btop"
    "carla"
    "fastfetch"
    "fish"
    "gtk-3.0"
    "gtk-4.0"
    "hypr"
    "imv"
    "kitty"
    "mpv"
    "nvim"
    "qt5ct"
    "qt6ct"
    "rofi"
    "swaync"
    "waybar"
    "wiremix"
    "yazi"
  ];

  binScripts = [
    "carla-mic-routing.sh"
    "davinci-run.sh"
    "mindustry"
    "start-davinci.sh"
  ];
in
{
  systemd.tmpfiles.rules = [
    # Base user directories
    "d ${homeDir}/.config 0755 ${user} users -"
    "d ${homeDir}/.local 0755 ${user} users -"
    "d ${homeDir}/.local/bin 0755 ${user} users -"
    "d ${homeDir}/.config/systemd 0755 ${user} users -"
    "d ${homeDir}/.config/systemd/user 0755 ${user} users -"

    # User systemd units
    "L+ ${homeDir}/.config/systemd/user/carla-mic.service - - - - ${repoDir}/config/systemd/user/carla-mic.service"

    # User desktop applications and icons
    "d ${homeDir}/.local/share 0755 ${user} users -"
    "d ${homeDir}/.local/share/applications 0755 ${user} users -"
    "d ${homeDir}/.local/share/icons 0755 ${user} users -"
    "L+ ${homeDir}/.local/share/applications/davinci.desktop - - - - ${repoDir}/desktop/applications/davinci.desktop"
    "L+ ${homeDir}/.local/share/icons/DV_Resolve.png - - - - ${repoDir}/desktop/icons/DV_Resolve.png"
  ]
  ++ (map linkConfig configDirs)
  ++ (map linkBin binScripts);
}
