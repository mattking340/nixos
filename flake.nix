{
  description = "DORIAN";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      nixosConfigurations.dorian = pkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hardware-configuration.nix

          {
            networking = {
              hostName = "dorian";
              networkmanager.enable = true;
            };

            services = {
              xserver = {
                enable = true;
                displayManager.lightdm.enable = true;
                desktopManager.xfce.enable = true;
              };
            };

            users.users.matt = {
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" ];
            };
            security.sudo.wheelNeedsPassword = false;

            environment.systemPackages = with pkgs; [
              firefox
              codium
              git
              neovim
              ghc
              cabal-install
              haskell-language-server
              fourmolu
              python3
            ];

            programs.vscode = {
              enable = true;
              package = pkgs.codium;
              extensions = with pkgs.vscode-extensions; [
                haskell.haskell
              ];
            };

            nixpkgs.config.allowUnfree = true;

            sound.enable = true;
            hardware.pulseaudio.enable = true;

            time.timeZone = "America/Toronto";
            i18n.defaultLocale = "en_CA.UTF-8";
          }
        ];
      };
    };
}
