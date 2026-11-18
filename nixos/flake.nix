{
  description = "v-nix system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprland.url = "github:hyprwm/Hyprland";

    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity = {
      url = "github:Hy4ri/antigravity-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rensa = {
      url = "github:qqvoil/rensa";
      inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs = { self, nixpkgs, hyprland, waybar, zen-browser, antigravity, rensa, ... }: {
    nixosConfigurations.v-nix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit hyprland; };
      modules = [
        ./configuration.nix
        hyprland.nixosModules.default
        {
          nixpkgs.overlays = [
            waybar.overlays.default
            antigravity.overlays.default
            (final: prev: {
              zen-browser = zen-browser.packages.${prev.stdenv.hostPlatform.system}.default;
              rensa = rensa.packages.${prev.stdenv.hostPlatform.system}.default;
            })
          ];
        }
      ];
    };
  };
}
