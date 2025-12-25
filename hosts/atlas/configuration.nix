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
    ../../modules/monitoring/ping-exporter.nix
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
    prometheus = {
      enable = true;
      nodeExporterTargets = [
        "localhost:9100"
        "localhost:9427"
      ];
    };
    grafana = {
      enable = true;
      domain = "localhost";
      prometheusUrl = "http://localhost:9090";
      dashboards = [
        {
          name = "node-exporter";
          url = "https://raw.githubusercontent.com/rfmoz/grafana-dashboards/master/prometheus/node-exporter-full.json";
          sha256 = "sha256-lOpPVIW4Rih8/5zWnjC3K0kKgK5Jc1vQgCgj4CVkYP4=";
        }
        {
          name = "ping-exporter";
          url = "https://raw.githubusercontent.com/rifqoi/nixos-config/refs/heads/main/grafana/dashboards/ping-exporter.json";
          sha256 = "sha256-EtUvolBtdH0LPNRHHs2p2m6fCR4aei9uzajrT0HIIuM=";
        }
      ];
    };

    pingExporter = {
      enable = true;
      settings = {
        targets = [
          "8.8.8.8"
          "1.1.1.1"
          "id.cloudflare.com"
          "detik.com"
          {
            "google.com" = {
              asn = 15169;
            };
          }
        ];
      };
    };
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
