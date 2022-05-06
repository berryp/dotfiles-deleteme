{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {

    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    # defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

    homeConfigurations = {
      gitpod = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        username = "gitpod";
        homeDirectory = "/home/gitpod";
        configuration.imports = [
          ./home-manager/modules/home-manager.nix
          ./home-manager/modules/fish.nix
          ./home-manager/modules/common.nix
          ./home-manager/modules/git.nix
          ./home-manager/gitpod.nix
        ];
      };  
    };
  };
}