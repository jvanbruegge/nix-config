{ pkgs, ... }:
{
  home-manager.users.jan = { pkgs, ... }: {
    imports = [
      ./nvim.nix
      ./git.nix
    ];

    home.packages = with pkgs; [
      nodejs
      pnpm
    ];
  };

  # Allow all users to use the ISP programmer
  services.udev.extraRules = ''
    KERNEL=="ttyACM0", MODE="0666"
  '';
}
