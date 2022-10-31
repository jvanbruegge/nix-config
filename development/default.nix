{ pkgs, ... }:
{
  home-manager.users.jan = { pkgs, ... }: {
    imports = [
      ./nvim.nix
      ./git.nix
      ./terminal.nix
    ];

    home.packages = with pkgs; [
      nodejs
      nodePackages.pnpm
    ];
  };

  # Allow all users to use the ISP programmer
  services.udev.extraRules = ''
    KERNEL=="ttyACM0", MODE="0666"
  '';
}
