{
  modulesPath,
  lib,
  pkgs,
  ...
} @ args:
{
  imports = [
    ../hosts/pawhost-next/hardware-configuration.nix
    ../modules/systemd-boot.nix
    ../modules/cicd.nix
    ./disk-config.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  services.openssh = {
    enable = true;
    ports = [ 666 ];
  };

  nix.settings.trusted-users = [ "root" "@wheel" "cicd" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.root.openssh.authorizedKeys.keys =
  [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4TfYrgjcXZd0q55fWHQqSwrGX8JwkF8kwUUNxj5wFA jura@juras-framework-12"
  ] ++ (args.extraPublicKeys or []); # this is used for unit-testing this module and can be removed if not needed
  security.sudo.wheelNeedsPassword = false;

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
  system.stateVersion = "25.05"; # Did you read the comment?
}