{
  pkgs,
  config,
  lib,
  ...
}: {
  sops.secrets.tailscale_auth_key = {
    sopsFile = ../../secrets/secrets.yaml;
    owner = "root";
    mode = "0400";
  };
  services.tailscale = {
    enable = true;
    package = pkgs.tailscale;
    settings = {
      ExitNodeAllowLANAccess = true;
    };
    # Authenticate this node on first boot
    authKeyFile = config.sops.secrets.tailscale_auth_key.path;
  };
}
