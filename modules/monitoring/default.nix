{...}: {
  imports = [
    ./prometheus.nix
    ./grafana.nix
    ./node-exporter.nix
    ./ping-exporter.nix
  ];
}
