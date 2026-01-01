{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.monitoring.nodeExporter;
in {
  # ============================================================================
  # MODULE OPTIONS
  # ============================================================================

  options.features.monitoring.nodeExporter = {
    enable = lib.mkEnableOption "Prometheus Node Exporter";

    port = lib.mkOption {
      type = lib.types.port;
      default = 9100;
      description = "Port for Node Exporter metrics";
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Address for node exporter metrics";
    };

    enabledCollectors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "systemd"
        "textfile"
        "filesystem"
        "loadavg"
        "meminfo"
        "netdev"
        "stat"
      ];
      description = "List of enabled collectors";
    };
  };

  # ============================================================================
  # MODULE IMPLEMENTATION
  # ============================================================================

  config = lib.mkIf cfg.enable {
    # --------------------------------------------------------------------------
    # NODE EXPORTER SERVICE
    # --------------------------------------------------------------------------

    services.prometheus.exporters.node = {
      enable = true;
      port = cfg.port;
      enabledCollectors = cfg.enabledCollectors;
      listenAddress = cfg.listenAddress;
    };

    # --------------------------------------------------------------------------
    # FIREWALL CONFIGURATION
    # --------------------------------------------------------------------------

    networking.firewall.allowedTCPPorts = [cfg.port];
  };
}
