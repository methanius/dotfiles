# Cross-host options for this flake's NixOS modules.
#
# Files prefixed with `_` are skipped by import-tree by default; this one is
# imported explicitly by modules/nixos/default.nix.
{ lib, ... }:
{
  options.my = {
    user.name = lib.mkOption {
      type = lib.types.str;
      description = ''
        Primary user account on this NixOS host.

        Read by both modules/nixos/default.nix (to declare users.users.<name>)
        and modules/nixos/home-manager.nix (to attach the HM module set to the
        same user). Each NixOS host must set this in hosts/<host>/system.nix;
        no default to force the choice to be explicit per host.
      '';
    };

    repoPath = lib.mkOption {
      type = lib.types.str;
      description = ''
        Absolute path to this dotfiles repo on the current NixOS host.

        Mirrored into the HM submodule via modules/nixos/home-manager.nix so
        Home-Manager modules that consume `my.repoPath` (out-of-store
        symlinks for nvim, terminals, atuin) get the host-specific value.
      '';
    };

    editor.neovim.extraRuntimePackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        Extra packages to put on the wrapped nvim's PATH on this NixOS host.

        Transport option: declared here so hosts/<host>/system.nix can set
        it cleanly, then forwarded into the HM submodule by
        modules/nixos/home-manager.nix. Has no NixOS-side semantic effect on
        its own; the actual consumer is the HM-scope option of the same
        name in modules/home/_options.nix.
      '';
    };
  };
}
