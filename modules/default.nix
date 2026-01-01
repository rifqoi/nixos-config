{...}: {
  imports = [
    ./monitoring
    ./virtualization/incus.nix
    ./storage/garage.nix
  ];
}
