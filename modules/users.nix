{ config, lib, pkgs, modulesPath, ... }:let
  mkUser = import ./make-user.nix { inherit lib pkgs; };
in {
  imports = [
    (mkUser "jura" "https://github.com/juravenator.keys")
    (mkUser "sirproko" "https://github.com/prokopyl.keys")
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}
