{
  description = "Siren's setup tm";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    hardware.url = "github:nixos/nixos-hardware";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs = { self, nixpkgs, hyprland, ... }@inputs: {
    nixosConfigurations = {
      eek14 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          hyprland.nixosModules.default
          {programs.hyprland.enable = true;}
        ];
      };
    };
  };
}
