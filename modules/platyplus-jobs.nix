{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  systemd.timers.platyplus-clean-cart = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m";
      Unit = "platyplus-clean-cart.service";
    };
  };

  systemd.services.platyplus-clean-cart = {
    script = ''
      #!/usr/bin/env bash
      set -o errexit -o nounset -o pipefail
      IFS=$'\n\t\v'
      ${pkgs.k3s}/bin/kubectl -n platyplus exec -it deploy/platyplus -- php index.php Cronjob action/SecretCronJob/clean
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };
}