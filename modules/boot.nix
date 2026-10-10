{ pkgs, ... }:
{
    boot = {
        supportedFilesystems = [ "ntfs" ]; # Enable kernel support for NTFS
        loader = {
            systemd-boot.enable = false;
            efi.canTouchEfiVariables = true; # can modify EFI boot variables
            grub = {
                enable = true;
                device = "nodev"; # don't write to an MBR
                efiSupport = true;

                # Install and Setup Grub Theme
                theme = pkgs.stdenv.mkDerivation {
                    pname = "distro-grub-themes-nixos";
                    version = "3.1";
                    src = pkgs.fetchFromGitHub {
                        owner = "AdisonCavani";
                        repo = "distro-grub-themes";
                        rev = "v3.1";
                        hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
                    };
                    dontBuild = true;
                    installPhase = ''
                        mkdir -p $out
                        tar -xf themes/nixos.tar -C $out
                    '';
                };
            };
        };
    };

    # Secure Boot key tooling
    environment.systemPackages = [ pkgs.sbctl ];
}
