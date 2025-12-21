{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common.nix
    ../../modules/networking/tailscale.nix
    ../../modules/monitoring/prometheus.nix
    ../../modules/monitoring/grafana.nix
    # (modulesPath + "/installer/scan/not-detected.nix")
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  services.zfs = {
    autoScrub.enable = true;
    autoScrub.interval = "monthly";
    autoSnapshot.enable = true;
  };

  networking.hostName = "atlas";
  networking.hostId = "6b53000e";

  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };

  features.monitoring = {
    prometheus.enable = true;
    grafana.enable = true;
  };

  programs = {
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        theme = "agnoster";
      };
    };

    starship = {
      enable = true;
    };
  };
}
