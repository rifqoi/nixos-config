{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.features.storage.garage;
in {
  options.features.storage.garage = {
    enable = lib.mkEnableOption "Garage storage for media files";

    ui.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Garage UI for managing media files";
    };

    ui.port = lib.mkOption {
      type = lib.types.port;
      default = 3909;
      description = "Port for Garage UI";
    };

    data_dir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/garage/data";
      description = "Directory for storing Garage media files";
    };

    metadata_dir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/garage/metadata";
      description = "Directory for storing Garage metadata files";
    };

    settings = lib.mkOption {
      type = lib.types.attrset;
      default = {};
      description = "Additional Garage configuration settings";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum ["debug" "info" "warn" "error"];
      default = "info";
      description = "Logging level for Garage service";
    };
  };

  config = lib.mkIf cfg.enable {
    service.garage = {
      enable = true;
      log_level = cfg.logLevel;
      settings = lib.recursiveUpdate cfg.settings {
        data_dir = cfg.data_dir;
        metadata_dir = cfg.metadata_dir;
      };
    };
  };

  virtualisation = lib.mkIf cfg.ui.enable {
    oci-containers.containers.garage-ui = {
      image = "khairul169/garage-webui:latest";
      ports = ["${toString cfg.ui.port}:3909"];
      volumes = [
        "/etc/garage.toml:/etc/garage.toml:ro"
      ];
      restartPolicy = "always";
    };
  };
}
