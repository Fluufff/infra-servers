{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "68bea79acfeca5af"
    ];
  };
}
