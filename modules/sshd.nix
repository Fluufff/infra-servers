{ name, config, lib, pkgs, modulesPath, ... }: {
  imports = [];

  services.openssh = {
    enable = true;
    ports = [ 666 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  services.fail2ban = {
    enable = true;
  };
  services.endlessh = {
    enable = true;
    port = 22;
#    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [ 22 666 6443 ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = true;

  environment.etc."motd.d/ascii".source = ./ssh-banners;

}
