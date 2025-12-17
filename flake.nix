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
    system = "aarch64-linux";
    lib = nixpkgs.lib;
    commonModules = [
    ];

    mkHost = extraModules:
      lib.nixosSystem {
        inherit system;
        modules = commonModules ++ extraModules;
      };
  in {
    nixosConfigurations = {
      vm = mkHost [
        disko.nixosModules.disko
        ./hosts/vm/disko.nix
        ./hosts/vm/default.nix
      ];
    };
  };
}
