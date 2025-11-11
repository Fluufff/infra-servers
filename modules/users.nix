{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  users.users.jura = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    #openssh.authorizedKeys.keyFiles = [
    #  /etc/nixos/github_ssh_keys/juravenator
    #];
  };
  users.users.proko = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    # openssh.authorizedKeys.keys = [ "lala" ];
    #openssh.authorizedKeys.keyFiles = [
    #  /etc/nixos/github_ssh_keys/proko
    #];
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}
