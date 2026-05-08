# dotfiles

Personal Nix flake managing both a standalone Home-Manager install on WSL and
a full NixOS system + Home-Manager install on a home machine. Organized using
the [dendritic pattern](https://github.com/mirkolenz/flocken) with
[`flake-parts`](https://flake.parts/) and
[`vic/import-tree`](https://github.com/vic/import-tree).

## Repository layout

```
.
├── flake.nix                       # tiny entry: mkFlake (import-tree ./modules/flake)
├── flake.lock
├── overlays/
│   └── default.nix                 # neovim-nightly overlay
├── modules/
│   ├── flake/                      # flake-parts modules (assembled by import-tree)
│   │   ├── systems.nix             # supported systems (x86_64-linux)
│   │   ├── overlays.nix            # perSystem pkgs with overlays + allowUnfree
│   │   ├── home-modules.nix        # registers self.homeModules.*
│   │   ├── nixos-modules.nix       # registers self.nixosModules.*
│   │   ├── nixos-configurations.nix# builds flake.nixosConfigurations.<host>
│   │   └── hosts/                  # one HM-host descriptor per file
│   │       ├── wsl.nix             #  -> homeConfigurations."clausormann@wsl"
│   │       └── _example.nix.disabled
│   ├── home/                       # Home-Manager modules (cross-host)
│   │   ├── _options.nix            # `my.*` HM-scope options
│   │   ├── default.nix             # aggregator: `self.homeModules.default`
│   │   ├── programs.nix
│   │   ├── shell/   editor/   terminal/   dev/   desktop/
│   └── nixos/                      # NixOS modules (cross-host)
│       ├── _options.nix            # `my.*` NixOS-scope options
│       ├── default.nix             # base system module
│       └── home-manager.nix        # wires HM into NixOS, forwards `my.*` options
├── hosts/
│   ├── wsl/
│   │   └── home.nix                # WSL-only HM extras (genericLinux, pip shim, ...)
│   ├── nixos/
│   │   ├── system.nix              # NixOS host facts (hostname, my.*, etc.)
│   │   └── hardware-configuration.nix
│   └── _example/                   # per-host template
│       └── home.nix.disabled
└── config/                         # plain dotfiles, live-symlinked via mkOutOfStoreSymlink
    ├── nvim/  ghostty/  wezterm/  alacritty/  atuin/  ...
```

### Conventions

- Files prefixed with `_` (e.g. `_options.nix`) are skipped by `import-tree`
  and imported explicitly. Used for option declarations that must be globally
  visible inside a module set.
- Files suffixed with `.disabled` are templates; remove the suffix and fill
  in placeholders to activate them.
- The whole `config/` tree is **not** Nix-managed. It's symlinked live into
  `~/.config/` via `config.lib.file.mkOutOfStoreSymlink "${my.repoPath}/..."`
  so edits apply without a rebuild. Tools managed this way: nvim, ghostty,
  wezterm, alacritty, atuin.

## Custom options (the `my.*` namespace)

Every host must set these. There are no defaults — eval will fail loudly if
something is missing on a new host, by design.

### HM scope (`modules/home/_options.nix`)

| Option | Type | Purpose |
|---|---|---|
| `my.repoPath` | `str` | Absolute path to this repo on the host. Read by every module that uses `mkOutOfStoreSymlink`. |
| `my.editor.neovim.extraRuntimePackages` | `listOf package`, default `[]` | Extra packages prepended to the wrapped `nvim` binary's PATH only (not user shell PATH). For lazy.nvim plugin builds (gcc/gnumake for treesitter parsers, cargo/rustc for blink.cmp) and tools nvim shells out to. |

### NixOS scope (`modules/nixos/_options.nix`)

| Option | Type | Purpose |
|---|---|---|
| `my.user.name` | `str` | Primary user account on this NixOS host. Drives both `users.users.<name>` and `home-manager.users.<name>`. |
| `my.repoPath` | `str` | Absolute path to this repo on this NixOS host. Forwarded into the HM submodule by `modules/nixos/home-manager.nix`. |
| `my.editor.neovim.extraRuntimePackages` | `listOf package`, default `[]` | Transport option. Forwarded into HM scope; has no NixOS-side semantic effect on its own. |

### Where each host sets them

- WSL — `modules/flake/hosts/wsl.nix` (inline module passed to `homeManagerConfiguration`).
- NixOS — `hosts/nixos/system.nix` (NixOS-scope options; HM-scope ones are forwarded automatically).

## Build & switch flow

### WSL (standalone Home-Manager)

```sh
# Build only (no activation, useful for verifying changes):
home-manager build --flake ".#clausormann@wsl"

# Build + activate:
home-manager switch --flake ".#clausormann@wsl"
```

The output of `build` is symlinked to `./result/`; inspect with
`./result/home-path/bin/nvim --version` etc.

#### One-time: enable the nix-community binary cache

Home-Manager on a non-NixOS host cannot rewrite `/etc/nix/nix.conf`, so the
substituter declared in `modules/nixos/default.nix` for the NixOS host does
**not** propagate here. Run this once per fresh WSL box so neovim-nightly
(and other `nix-community` artifacts) come down prebuilt instead of
rebuilding from source:

```sh
nix-env -iA cachix -f https://cachix.org/api/v1/install   # if cachix not yet installed
sudo $(which cachix) use nix-community
sudo systemctl restart nix-daemon                          # or: sudo pkill -HUP nix-daemon
```

`cachix use` edits `/etc/nix/nix.conf` non-destructively (appends, dedupes,
preserves `cache.nixos.org`). Verify with
`nix show-config | grep -E '^(substituters|trusted-public-keys) '`.

### NixOS (system + HM as a NixOS module)

```sh
# Build only:
sudo nixos-rebuild build --flake "/home/normann/dotfiles#nixos"

# Build + activate (current generation):
sudo nixos-rebuild switch --flake "/home/normann/dotfiles#nixos"

# First-time bring-up: replace hosts/nixos/hardware-configuration.nix with the
# real one before switching:
sudo nixos-generate-config --show-hardware-config > hosts/nixos/hardware-configuration.nix
```

Home-Manager is enabled inside the NixOS configuration via
`modules/nixos/home-manager.nix` with `useGlobalPkgs` and `useUserPackages`,
so there's no separate `home-manager switch` on NixOS — the system rebuild
covers both.

### Inspecting evaluated config

```sh
# What does HM see for the WSL host?
nix eval --json '.#homeConfigurations."clausormann@wsl".config.my'

# What runtime packages reach the wrapped nvim on NixOS?
nix eval --json \
  '.#nixosConfigurations.nixos.config.home-manager.users.normann.my.editor.neovim.extraRuntimePackages' \
  --apply 'xs: map (p: p.pname or p.name) xs'
```

## Desktop module (sway)

`self.homeModules.desktop` (in `modules/home/desktop/default.nix`) bundles
the full sway stack: `wayland.windowManager.sway` with i3-style keybinds
(Mod1/Alt main modifier, Mod4+L for swaylock), `programs.waybar` styled in
the Tomorrow Night palette, `programs.swaylock`, `services.swayidle`, and a
systemd user timer (`swww-rotate.timer`) that picks a random wallpaper from
`~/Pictures/wallpapers` every 15 min via swww.

It is opt-in per host: not in the cross-host `modules/home/default.nix`
imports list. The NixOS host pulls it in via
`modules/nixos/home-manager.nix`; WSL does not. System-side requirements
(`programs.sway`, `xdg.portal`, swaylock PAM) live in
`hosts/nixos/system.nix`.

The wallpaper directory is **not** managed by this repo. Create it and
populate it manually:

```sh
mkdir -p ~/Pictures/wallpapers
# drop .jpg/.jpeg/.png/.webp files in
systemctl --user start swww-rotate.timer    # picks up automatically on next login
systemctl --user start swww-rotate.service  # trigger an immediate rotation
```

If the directory is missing or empty the rotator no-ops; the bg falls back
to the solid Tomorrow Night background `#282A2E` set in the sway config.

## Adding a new HM host

1. Copy `modules/flake/hosts/_example.nix.disabled` →
   `modules/flake/hosts/<name>.nix`; fill in `username`, `homeDirectory`,
   `my.repoPath`, and any `my.editor.neovim.extraRuntimePackages` the host
   needs.
2. (Optional) Copy `hosts/_example/home.nix.disabled` →
   `hosts/<name>/home.nix` for host-only HM extras (analogous to
   `hosts/wsl/home.nix`). Reference it from your new flake/hosts file.
3. Build: `home-manager build --flake ".#<user>@<host>"`.

## Adding a new NixOS host

1. Add a new file under `hosts/<name>/system.nix` setting `networking.hostName`,
   `my.user.name`, `my.repoPath`, any host-specific runtime extras, and
   `system.stateVersion`.
2. Generate `hosts/<name>/hardware-configuration.nix` on the target box.
3. Register it in `modules/flake/nixos-configurations.nix` (mirror the existing
   `nixos` entry).
4. `sudo nixos-rebuild switch --flake "<repoPath>#<name>"`.

## Notes

- `flake.lock` is intentionally kept stable — newer nixpkgs revisions have
  triggered an opencode segfault for me. Bump deliberately, not opportunistically.
- Repository is private. The atuin sync URL in `config/atuin/config.toml` and
  the WSL pip-token shim in `hosts/wsl/home.nix` (which reads
  `~/pip-token-mftus` at runtime, never embedding the token in the store) are
  the only borderline-secret items; both are flagged with comments.
