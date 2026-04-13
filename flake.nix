{
  description = "Delle — NixOS configuration for Dell Precision M2800";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    openclaw-nix = {
      url = "github:Scout-DJ/openclaw-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, openclaw-nix, ... }@inputs: {
    nixosConfigurations.delle = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        disko.nixosModules.disko
        openclaw-nix.nixosModules.default
        home-manager.nixosModules.home-manager

        ./hosts/delle/default.nix

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.craole = import ./home/craole.nix;
          };
        }
      ];
    };
  };
}
