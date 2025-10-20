{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # environment.etc."cicd.sh" = {
  #   source = ./cicd.sh;
  #   mode = "0755";
  # };

  users.users.cicd = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      # "command=\"/etc/cicd.sh\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLDp+dxw5A2r89I0Fqm95C2DID1PjWj3ruNyV3XmFro CICD"
      "no-port-forwarding,no-X11-forwarding,no-agent-forwarding ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLDp+dxw5A2r89I0Fqm95C2DID1PjWj3ruNyV3XmFro CICD"
    ];
  };
}