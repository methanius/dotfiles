# Cross-host options for this flake's Home-Manager modules.
#
# Files prefixed with `_` are skipped by import-tree by default; this one is
# imported explicitly by modules/home/default.nix.
{ lib, ... }:
{
  options.my = {
    repoPath = lib.mkOption {
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

    editor.neovim.extraRuntimePackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        Extra packages prepended to the wrapped `nvim` binary's PATH only
        (not the user's shell PATH). Intended for runtime toolchains that
        lazy.nvim plugin builds invoke (gcc/gnumake for treesitter parser
        compilation, cargo/rustc for blink.cmp's `cargo build --release`)
        and tools nvim shells out to via `:!` or `:terminal`.

        Hosts opt in per-host: WSL leaves this empty, NixOS sets the
        compile toolchain it needs at runtime since prebuilt plugin
        binaries can't link against system glibc on NixOS.
      '';
    };
  };
}
