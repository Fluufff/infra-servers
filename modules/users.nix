{ config, lib, pkgs, modulesPath, ... }:let
  mkUser = import ./make-user.nix { inherit lib pkgs; };
in {
  imports = [
    (mkUser "jura" "https://github.com/juravenator.keys")
    (mkUser "sirproko" "https://github.com/prokopyl.keys")
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    lolcat
    jq
  ];

  services.openssh = {
    settings = {
      PrintMotd = false;
      PrintLastLog = false;
    };
  };

  environment.etc."motd.d/banners".source = ./sshd-motd/banners;
  environment.etc."update-motd.d/00-header" = {
    source = ./sshd-motd/00-header;
    mode = "0755";
  };

  programs.zsh.shellInit = ''
    if [[ $- == *i* ]]; then
      . /etc/update-motd.d/00-header
    fi
  '';

}
