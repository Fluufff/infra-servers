{ config, pkgs, ... }:

let
  execAuditRules = ''
    # record execve/execveat for normal users (auid >= 1000) and tag them
    -a always,exit -F arch=b64 -S execve -S execveat -F auid>=1000 -F auid!=4294967295 -k exec_log
    -a always,exit -F arch=b32 -S execve -S execveat -F auid>=1000 -F auid!=4294967295 -k exec_log
  '';
in
{
  security.auditd.enable = true;
  security.audit.enable = true; # "lock"

  # persist rules
  # environment.etc."audit/rules.d/99-exec.rules".text = execAuditRules;
  security.audit.rules = [
    "-a always,exit -F arch=b64 -S execve -S execveat -F auid>=1000 -F auid!=4294967295 -k exec_log"
    "-a always,exit -F arch=b32 -S execve -S execveat -F auid>=1000 -F auid!=4294967295 -k exec_log"
  ];

  #environment.systemPackages = with pkgs; [
  #  tlog
  #];

  # Add PAM TTY audit for sudo so keystrokes go to the audit subsystem (optional)
  # This writes /etc/pam.d/sudo which must be consistent with your existing sudo PAM stack.
  #environment.etc."pam.d/sudo".text = ''
  #  #%PAM-1.0
  #  auth       include       system-auth
  #  account    include       system-auth
  #  password   include       system-auth
  #  session    required      pam_tty_audit.so enable=*
  #  session    include       system-auth
  #'';

  # Logging & rotation: auditd handles its own rotation; ensure /var/log/audit has enough space.
  # Consider forwarding audit logs to a remote log collector (rsyslog/elastic/Graylog/etc.)

}
