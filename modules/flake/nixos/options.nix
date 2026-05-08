# NixOS-side options exposed by this flake.
#
# Contributes to `flake.modules.nixos.base` so every NixOS configuration
# in this flake gets the option scope.
{
  flake.modules.nixos.base =
    { lib, ... }:
    {
      options.my = {
        user.name = lib.mkOption {
          type = lib.types.str;
          description = ''
            Primary user account on this NixOS host.

            Read by the base role (to declare users.users.<name>) and by
            modules/flake/hosts/nixos.nix (to attach the HM module set to
            the same user). Each NixOS host must set this in its host file;
            no default to force the choice to be explicit per host.
          '';
        };

        repoPath = lib.mkOption {
          type = lib.types.str;
          description = ''
            Absolute path to this dotfiles repo on the current NixOS host.

            Mirrored into the HM submodule via modules/flake/hosts/nixos.nix
            so Home-Manager modules that consume `my.repoPath` (out-of-store
            symlinks for nvim, terminals, atuin) get the host-specific value.
          '';
        };

        editor.neovim.extraRuntimePackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = ''
            Extra packages to put on the wrapped nvim's PATH on this NixOS host.

            Transport option: declared here so the host file can set it
            cleanly, then forwarded into the HM submodule by
            modules/flake/hosts/nixos.nix. Has no NixOS-side semantic effect
            on its own; the actual consumer is the HM-scope option of the
            same name.
          '';
        };
      };
    };
}
