{
  description = "Rifqoi's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    disko,
    ...
  }: let
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      vm = lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          disko.nixosModules.disko
          ./hosts/vm/disko.nix
          ./hosts/vm/configuration.nix
        ];
      };

      atlas = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./hosts/atlas/disko.nix
          ./hosts/atlas/configuration.nix
        ];
      };
    };
  };
}
