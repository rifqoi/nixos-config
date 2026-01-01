{
  config,
  lib,
  pkgs,
  options,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.features.monitoring.pingExporter;
in {
  # ============================================================================
  # MODULE OPTIONS
  # ============================================================================

  options.features.monitoring.pingExporter = {
    enable = mkEnableOption "Prometheus Ping Exporter";

    port = lib.mkOption {
      type = types.port;
      default = 9427;
      description = "Port for Ping Exporter metrics";
    };
    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Address for node exporter metrics";
    };
    settings = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Configuration for ping_exporter, see
        <https://github.com/czerwonk/ping_exporter>
        for supported values.
      '';
    };
  };

  config = mkIf cfg.enable {
    # --------------------------------------------------------------------------
    # SERVICE DEFINITION
    # --------------------------------------------------------------------------
    services.prometheus.exporters.ping = {
      enable = true;
      port = cfg.port;
      settings = cfg.settings;
      listenAddress = cfg.listenAddress;
    };

    # --------------------------------------------------------------------------
    # FIREWALL CONFIGURATION
    # --------------------------------------------------------------------------
    networking.firewall.allowedTCPPorts = [cfg.port];
  };
}
