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

  systemd.timers.platyplus-sql-backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1h";
      OnUnitActiveSec = "1h";
      Unit = "platyplus-sql-backup.service";
    };
  };

  systemd.services.platyplus-sql-backup = {
    script = ''
      #!/usr/bin/env bash
      set -o errexit -o nounset -o pipefail
      IFS=$'\n\t\v'
      ${pkgs.k3s}/bin/kubectl -n platyplus exec -it deploy/mariadb -- mariadb-dump -u root "-pExtruding-Tibia7-Colt" --lock-tables fluufff > /data/platyplus/sql-backups/mariadb-dump-next-$(date "+%Y-%m-%d-%H-%M-%S").sql
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };
}