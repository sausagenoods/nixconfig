{
  description = "Siren's setup tm";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    hardware.url = "github:nixos/nixos-hardware";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?ref=master&rev=a770a88e0962f37c0b6f36f1876cbf27db4cf3c9&submodules=1";
  };

  outputs = { self, nixpkgs, hyprland, ... }@inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    nixosConfigurations = {
      eek14 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          hyprland.nixosModules.default
          { programs.hyprland.enable = true; }
        ];
      };
    };
  };
}
