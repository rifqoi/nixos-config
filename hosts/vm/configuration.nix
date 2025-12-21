# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    # ./hardware-configuration.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

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

  # ZFS tends to mount filesystems very early during the boot process.
  # Tell the system that this is not needed for boot.
  # Disko will implictly set this in the initial installation.
  fileSystems = {
    "/var".neededForBoot = false;
    "/home".neededForBoot = false;
    "/var/lib/vms".neededForBoot = false;
    "/var/lib/postgresql" = {
      neededForBoot = false;
      options = [
        # "nofail"
        "x-systemd.mount-timeout=15s"
      ];
    };
  };

  networking = {
    hostName = "nixos";
    hostId = "6b53000e";
  };
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rifqoi = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    home = "/home/rifqoi";
    initialHashedPassword = "$y$j9T$l53/GZBc310luydwDlOV00$FlIUZw3mG2L3/oRuZc17jFW/CPEgbVbjZfYv2yBHgR3";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCa6pwAycAyKJTorMxeAQOatJgnhkqUag7moO2MD3LPYficF1sBu5hmqpIdJMNs5+YOY59TeKc8WZOQteSH1NIZ/22Yr+qpGupKFPqDhbk7kYMJKOXFTR+eja6d7oi8AXZXU7cN1SszMWlqFuxljRIyCuvLDHiwmBJVOkGuisuOyVC9OzjqNQCMNDbXHBM8tYNAe6k1od/nBI1g2XPXL8DC6MsB0aesHI+Z6ZRV3nShBoYJMEYDYg26xbtZTavVhTcvTRaXyfWblJZvxkgy0LQdeyz4Ts9o2YuHo2I+Qx52c8tiXWwPgjh+QJ01GYboKAfSvdTfFxdmNpPCNaOOyavJbvMwxjTnqOnGThXka7LN2ytOYGkPJ89RGgF26T+Oo24m1omobBJR5kkDSV1/BNOlOHqxeljeWuvaceHVhXm2WH+3ziE35Uym0bZ3+f2+B9upkRE3azXFY6K6SCGd6gtGnZy1m+9K3Gpcqs5wj98b5obGkccr/jCtjZjKqZahy4k= mrifqi@MuhammadRifqiAlFurqon-MacBook-Pro.local"
    ];

    packages = with pkgs; [
      tree
    ];
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

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
