{ name, config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  networking.hostName = name;
  # networking.networkmanager.enable = true;

  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.trusted-users = [ "root" "@wheel" "cicd" ];

  # We only have ssh keys, no passwords.
  # Not setting this would cause lockout.
  security.sudo.wheelNeedsPassword = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
    settings.auto-optimise-store = true; # <- this option will hardlink identical files
  };

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
  '';

  boot.loader.grub.configurationLimit = 16;
  boot.loader.systemd-boot.configurationLimit = 16;

  environment.systemPackages = with pkgs; [
    vim
    htop
    curl
    git
    jq
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #system.copySystemConfiguration = true;
}
