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
    ../../modules/virtualization/incus.nix
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
    timeout = 5;
    timeoutStyle = "menu";

    zfsSupport = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = ["zfs"];
  boot.initrd.supportedFilesystems = ["zfs"];

  fileSystems."/" = {
    device = "rpool/root/ROOT/nixos";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/home";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "rpool/var";
    fsType = "zfs";
  };

  fileSystems."/var/lib/vms" = {
    device = "rpool/vm";
    fsType = "zfs";
  };

  fileSystems."/var/lib/postgresql" = {
    device = "rpool/postgresql";
    fsType = "zfs";
  };

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

  features = {
    monitoring = {
      prometheus = {
        enable = true;
        nodeExporterTargets = [
          "localhost:9100"
          "localhost:9427"
          "100.71.151.87:9100"
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
            sha256 = "sha256-ZmzCak5jAaUA4jKjKcN4mC2SjBsHZXcQf4I7bhoetoY=";
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
            {
              "google.com" = {
                asn = 15169;
              };
            }
          ];
        };
      };
    };

    virtualization.incus = {
      enable = true;
      enableUI = true;
      preseed = {
        config = {
          "core.https_address" = ":8999";
        };
        networks = [
          {
            name = "incusbr0";
            type = "bridge";
            description = "NAT bridge";
            config = {
              "ipv4.address" = "auto";
              "ipv4.nat" = "true";
              "ipv6.address" = "auto";
              "ipv6.nat" = "true";
            };
          }
        ];
        profiles = [
          {
            name = "default";
            description = "Default Incus Profile";
            devices = {
              eth0 = {
                name = "eth0";
                network = "incusbr0";
                type = "nic";
              };
              root = {
                path = "/";
                pool = "default";
                type = "disk";
              };
            };
          }
        ];
        storage_pools = [
          {
            name = "default";
            driver = "zfs";
            config = {
              source = "rpool/vm";
            };
          }
        ];
      };
      networking = {
        allowedTCPPorts = [53 67];
        allowedUDPPorts = [53 67];
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
