# Cross-host options for this flake's Home-Manager modules.
#
# Files prefixed with `_` are skipped by import-tree by default; this one is
# imported explicitly by modules/home/default.nix.
{lib, ...}: {
  options.my.repoPath = lib.mkOption {
    type = lib.types.str;
    description = ''
      Absolute path to this dotfiles repo on the current machine.

      Consumed by modules that live-symlink config/<tool>/ via
      mkOutOfStoreSymlink (nvim, ghostty, wezterm, alacritty, atuin) so
      edits to those subdirs apply without a Home-Manager rebuild. Each
      host sets its own value; no default to force the choice to be
      explicit per host.
    '';
  };
}
