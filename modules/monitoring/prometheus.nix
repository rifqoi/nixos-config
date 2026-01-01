{
  config,
  lib,
  ...
}: let
  cfg = config.features.monitoring.prometheus;
in {
  # ============================================================================
  # MODULE OPTIONS
  # ============================================================================

  options.features.monitoring.prometheus = {
    enable = lib.mkEnableOption "Prometheus monitoring server";

    port = lib.mkOption {
      type = lib.types.port;
      default = 9090;
      description = "Port for Prometheus web interface";
    };

    scrapeConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [];
      description = "Additional scrape configurations";
    };

    nodeExporterTargets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of node exporter targets (host:port)";
    };
  };

  # ============================================================================
  # MODULE IMPLEMENTATION
  # ============================================================================

  config = lib.mkIf cfg.enable {
    # --------------------------------------------------------------------------
    # PROMETHEUS SERVICE
    # --------------------------------------------------------------------------

    services.prometheus = {
      enable = true;
      port = cfg.port;
      checkConfig = "syntax-only";
      globalConfig.scrape_interval = "30s";
      retentionTime = "7d";

      scrapeConfigs =
        [
          # Self-monitoring
          {
            job_name = "prometheus";
            static_configs = [
              {
                targets = ["localhost:${toString cfg.port}"];
              }
            ];
          }

          # Node exporters - auto-discover features hosts
          {
            job_name = "node-exporter";
            static_configs = [
              {
                targets = cfg.nodeExporterTargets;
              }
            ];
          }
        ]
        ++ cfg.scrapeConfigs;
    };

    # --------------------------------------------------------------------------
    # FIREWALL CONFIGURATION
    # --------------------------------------------------------------------------

    networking.firewall.allowedTCPPorts = [cfg.port];
  };
}
