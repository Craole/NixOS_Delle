{
  description = "Delle — NixOS configuration for Dell Precision M2800";

  inputs = {
    NixPackages.url = "github:NixOS/nixpkgs/nixos-unstable";
    HomeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "NixPackages";
    };
    Disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "NixPackages";
    };
    OpenClaw = {
      url = "github:Scout-DJ/openclaw-nix";
      inputs.nixpkgs.follows = "NixPackages";
    };
    AI = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "NixPackages";
    };
  };

  outputs = inputs @ {
    self,
    NixPackages,
    HomeManager,
    Disko,
    OpenClaw,
    ...
  }: let
    lib = NixPackages.lib;
    mkHost = {
      name,
      system ? "x86_64-linux",
      extraModules ? [],
    }:
      lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs name;
          dom = "_";
        };
        modules =
          [
            Disko.nixosModules.disko
            OpenClaw.nixosModules.default
            HomeManager.nixosModules.home-manager
            ./modules
            ./users
            ./hosts/${name}
          ]
          ++ extraModules;
      };
  in {
    nixosConfigurations = {
      delle = mkHost {name = "delle";};
    };

    formatter.x86_64-linux = NixPackages.legacyPackages.x86_64-linux.alejandra;
  };
}
