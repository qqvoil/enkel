{ pkgs, ... }: {
  users.users.voil = {
    isNormalUser = true;
    hashedPasswordFile = "/etc/nixos/secrets/password-hash";
    extraGroups = [ "wheel" "video" "audio" "networkd" "input" ];
    shell = pkgs.fish;
  };

  security.sudo.extraRules = [{
    users = [ "voil" ];
    commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
  }];
}
