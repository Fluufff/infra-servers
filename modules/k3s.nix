{ name, config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  services.k3s = {
    enable = true;
    role = "server";
  };

}
