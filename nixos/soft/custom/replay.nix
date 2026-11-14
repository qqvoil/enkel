{ config, pkgs, ... }:

let
  save-replay = pkgs.writeShellScriptBin "save-replay" ''
    if ! ${pkgs.procps}/bin/pgrep -x .obs-wrapped >/dev/null && ! ${pkgs.procps}/bin/pgrep -x obs >/dev/null; then
      ${pkgs.libnotify}/bin/notify-send -u normal -a "OBS Replay" "OBS is not running" "Start OBS to enable replay buffer"
      exit 1
    fi

    if ${pkgs.obs-cmd}/bin/obs-cmd --websocket obsws://127.0.0.1:4455 replay save 2>/dev/null; then
      ${pkgs.libnotify}/bin/notify-send -u low -a "OBS Replay" "Replay Saved" "Saved last 10 minutes to ~/data/Highlights"
    else
      ${pkgs.libnotify}/bin/notify-send -u normal -a "OBS Replay" "Save Failed" "Ensure Replay Buffer is active in OBS"
    fi
  '';
in
{
  environment.systemPackages = [
    pkgs.obs-cmd
    save-replay
  ];

  # Declarative initial setup for OBS configs (seeds defaults if not already present)
  system.activationScripts.obsInitialConfig = {
    text = ''
      TARGET_USER="voil"
      TARGET_HOME="/home/$TARGET_USER"
      OBS_DIR="$TARGET_HOME/.config/obs-studio"
      HIGHLIGHTS_DIR="$TARGET_HOME/data/Highlights"

      if [ -d "$TARGET_HOME" ]; then
        # Ensure Highlights directory exists
        mkdir -p "$HIGHLIGHTS_DIR"
        chown "$TARGET_USER:users" "$HIGHLIGHTS_DIR"

        # Global OBS config
        mkdir -p "$OBS_DIR"
        if [ ! -f "$OBS_DIR/global.ini" ]; then
          cp ${./obs/global.ini} "$OBS_DIR/global.ini"
          chmod 644 "$OBS_DIR/global.ini"
        fi

        # WebSocket plugin config
        mkdir -p "$OBS_DIR/plugin_config/obs-websocket"
        if [ ! -f "$OBS_DIR/plugin_config/obs-websocket/config.json" ]; then
          cp ${./obs/websocket-config.json} "$OBS_DIR/plugin_config/obs-websocket/config.json"
          chmod 644 "$OBS_DIR/plugin_config/obs-websocket/config.json"
        fi

        # Profile config (10-min replay buffer, AV1 NVENC, FLAC multi-track)
        mkdir -p "$OBS_DIR/basic/profiles/Untitled"
        if [ ! -f "$OBS_DIR/basic/profiles/Untitled/basic.ini" ]; then
          cp ${./obs/basic.ini} "$OBS_DIR/basic/profiles/Untitled/basic.ini"
          chmod 644 "$OBS_DIR/basic/profiles/Untitled/basic.ini"
        fi

        if [ ! -f "$OBS_DIR/basic/profiles/Untitled/recordEncoder.json" ]; then
          cp ${./obs/recordEncoder.json} "$OBS_DIR/basic/profiles/Untitled/recordEncoder.json"
          chmod 644 "$OBS_DIR/basic/profiles/Untitled/recordEncoder.json"
        fi

        # Default scenes collection
        mkdir -p "$OBS_DIR/basic/scenes"
        if [ ! -f "$OBS_DIR/basic/scenes/Untitled.json" ]; then
          cp ${./obs/scenes.json} "$OBS_DIR/basic/scenes/Untitled.json"
          chmod 644 "$OBS_DIR/basic/scenes/Untitled.json"
        fi

        chown -R "$TARGET_USER:users" "$OBS_DIR"
      fi
    '';
  };

  # Declarative background Replay Buffer service managed by systemd
  # Bound to graphical-session.target so it shuts down cleanly BEFORE Hyprland exits
  systemd.user.services.obs-replay-buffer = {
    description = "OBS Studio Replay Buffer (Shadowplay)";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${config.programs.obs-studio.finalPackage}/bin/obs --startreplaybuffer --minimize-to-tray";
      ExecStop = pkgs.writeShellScript "stop-obs-replay" ''
        # 1. Gracefully stop replay buffer via websocket to flush NVENC
        ${pkgs.obs-cmd}/bin/obs-cmd --websocket obsws://127.0.0.1:4455 replay stop 2>/dev/null || true
        # 2. Request clean application quit
        ${pkgs.procps}/bin/kill -SIGINT $MAINPID 2>/dev/null || true
      '';
      KillMode = "mixed";
      TimeoutStopSec = "5s";
      Restart = "on-failure";
      RestartSec = "3s";
    };
  };
}
