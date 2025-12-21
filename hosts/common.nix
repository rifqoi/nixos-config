{pkgs, ...}: {
  ############ SERVICES ############
  services.openssh = {
    enable = true;
    settings = {
      passwordAuthentication = false;
    };
  };

  ############ PROGRAMS ############
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
  ############ NIX ############
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  ############ PACKAGES ############
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    git
    curl
  ];

  ############ USERS ############
  users.users.rifqoi = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "libvirtd" "docker" "audio" "video" "render" "zfs"];
    shell = pkgs.zsh;
    home = "/home/rifqoi";
    hashedPassword = "$y$j9T$gI0IkZGfLkKkywgyQgVbP.$gX9LyM78XxsqwckJdxmeJbFSi1h/eZz2OrDR1zVesj1";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYn/VgsdSj/eBElypa+Pi6qmvNWhtSYWLI2Mas4ieL/S+qFcZz4v2f8HdCOwAAITRYhxvnY3n9QIBHoFJrfD0pFgIeOKloGUOZXrlWYl8kfUlvfOo3D1WsS+N4rl5AYH2lCDQ+Rg9rvYYxr06JhCb1/Zj0aI1RJs6gtofBnie2b6ezqleXpYBfKAYF/NQATk2x+2dckwSqjTDmvlXOWWBOMrgg6UB572D556QzqqaTyRmpGXtBgNQb/yWGG6fus20u/RiVKj60B5Vj0RqEfIGtOMVaRTyE0kGWuTDUP3WA4awiDRTEJqSRtTNFWWfd//Op3rAOndjcy4eP7LY8S0laKkTurV9FOYlZyBV5pFHgJto5XYUjG5HhIuzyVDWTbt47g07WOjGDj6Lis5OOkrtf56xF2NLJXtMpQwY8UMa/+6DZG7J0ixEqnYDvZ/J/fMQxmP51UEwHKh+3EYcMoB7twXUPlTqUhbhhZ4wOJZlqxwmrnSda5KkYJR7mGATbc60= rifqoi@home"
    ];

    packages = with pkgs; [
      tree
    ];
  };

  ############ USERS ############
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  ############ NETWORKING ############
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [22];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "25.11";
}
