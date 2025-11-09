{
  description = "DORIAN";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }:
    {
      nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hardware-configuration.nix

          {
            networking.hostName = "dorian";

            services.xserver.enable = true;
            services.xserver.displayManager.gdm.enable = true;
            services.xserver.desktopManager.gnome.enable = true;

            users.users.matt = {
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" ];
            };

            security.sudo.wheelNeedsPassword = false;

            environment.systemPackages = with nixpkgs.pkgs; [
              firefox
              vscode
              git
              neovim
            ];

            nixpkgs.config.allowUnfree = true;

            sound.enable = true;
            hardware.pulseaudio.enable = true;

            networking.networkmanager.enable = true;

            time.timeZone = "America/Toronto";
            i18n.defaultLocale = "en_CA.UTF-8";
          }
        ];
      };
    };
}
