{
  description = "Robin's NixOS system";

  inputs = {
    nixpkgs-system.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-home.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-home";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # ADD THIS:
    noctalia.url = "github:noctalia-dev/noctalia";
  };

  outputs = { self, nixpkgs-system, nixpkgs-home, home-manager, zen-browser, noctalia, ... }@inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs-home {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.transcendent = nixpkgs-system.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit zen-browser; };
      modules = [
        ./configuration.nix
      ];
    };

    homeConfigurations.isandrin =
      home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        extraSpecialArgs = { inherit inputs; }; # PASS INPUTS HERE
        modules = [
          ./home/isandrin.nix
        ];
      };
  };
}
