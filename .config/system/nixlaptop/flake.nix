{
  description = "Laptop NixOS configuration.";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    themes = { url = "github:RGBCube/ThemeNix"; };
  };

  outputs = { self, nixpkgs, themes, home-manager, ... }@inputs:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      theme = themes.catppuccin-frappe;
    in {
      nixosConfigurations.nixlaptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mbarria = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
}
