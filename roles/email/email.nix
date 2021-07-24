{ config, pkgs, ... }:

{
  imports = [
    ./neomutt.nix
    ./futurice.com.nix
    ./vanbruegge.de.nix
    ./gmail.com.nix
  ];
}
