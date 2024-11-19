{
  description = "Anarcho NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... } @ inputs: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        nixvm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/nixvm/configuration.nix
            
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                };
                users.anarcho = ./home/anarcho/nixvm.nix;
              };
            }

            hyprland.nixosModules.default
            { programs.hyprland.enable = true; }
          ];
          specialArgs = {
            inherit inputs;
          };
        };
      };
    };
}