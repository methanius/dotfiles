# dotfiles

Personal Nix flake managing both a standalone Home-Manager install on WSL
and a full NixOS system + Home-Manager on a home machine. Built strictly on
the [dendritic pattern](https://github.com/mightyiam/dendritic) using
[`flake-parts`](https://flake.parts/),
[`vic/import-tree`](https://github.com/vic/import-tree), and the
[`flake-parts.flakeModules.modules`](https://flake.parts/options/flake-parts-modules.html)
namespace.

## Required reading

If you've not seen the dendritic pattern before, read these in order before
making changes — the structure here will look strange otherwise:

1. https://dendritic.oeiuwq.com/ — high-level intro to the pattern
2. https://github.com/mightyiam/dendritic — reference implementation
3. https://flake.parts/options/flake-parts-modules.html — the
   `flake.modules.<class>.<name>` namespace this flake uses for everything
4. https://github.com/vic/import-tree — auto-discovery rules
   (`.nix` files only, paths containing `/_` are skipped)

## What "strict dendritic" means here

- **Every** `.nix` file under `modules/flake/` is a flake-parts module.
- There are no plain Home-Manager or NixOS modules sitting in some
  `modules/home/` aggregator. Tools, roles, and hosts are *all*
  flake-parts modules contributing to `flake.modules.<class>.<name>`.
- Module-merge does the heavy lifting: when ten files declare
  `flake.modules.homeManager.workstation-user = { ... }: { ... };`,
  flake-parts merges them into a single composite Home-Manager module
  that hosts then import as a unit.
- `flake.nix` itself is six lines — it just hands `import-tree` to
  `mkFlake`. There is no logic to read at the top level.

## Repository layout

```
.
├── flake.nix                       # 6-line entry: mkFlake (import-tree ./modules/flake)
├── flake.lock
├── modules/
│   ├── flake/                      # ALL flake-parts modules (auto-discovered)
│   │   ├── checks.nix              # perSystem.checks.nixfmt (gates every commit)
│   │   ├── nixpkgs.nix             # option α: accumulate overlays, build pkgs once
│   │   ├── systems.nix             # supported systems
│   │   ├── home/                   # contributions to flake.modules.homeManager.*
│   │   │   ├── base.nix            #  → base role (HM invariants + state version)
│   │   │   ├── options.nix         #  → base role (my.repoPath, etc.)
│   │   │   ├── shell-fish.nix      #  → base role
│   │   │   ├── shell-zsh.nix       #  → base role
│   │   │   ├── shell-starship.nix  #  → base role
│   │   │   ├── dev.nix             #  → base role (cargo/go/jujutsu/...)
│   │   │   ├── programs.nix        #  → base role (fzf/atuin/eza/yazi/zoxide/...)
│   │   │   ├── editor-neovim.nix   #  → workstation-user (also adds nightly overlay)
│   │   │   ├── terminal-ghostty.nix#  → workstation-user
│   │   │   ├── terminal-wezterm.nix#  → workstation-user
│   │   │   ├── terminal-alacritty.nix # → workstation-user
│   │   │   ├── desktop-sway.nix    #  → workstation-user
│   │   │   ├── desktop-waybar.nix  #  → workstation-user
│   │   │   ├── desktop-fuzzel.nix  #  → workstation-user
│   │   │   ├── desktop-swaylock.nix#  → workstation-user
│   │   │   ├── desktop-swayidle.nix#  → workstation-user
│   │   │   ├── desktop-wallpaper.nix # → workstation-user
│   │   │   └── host-wsl.nix        #  → host-wsl (per-host bits)
│   │   ├── nixos/                  # contributions to flake.modules.nixos.*
│   │   │   ├── base.nix            #  → base role (nix.settings, user, ...)
│   │   │   ├── options.nix         #  → base role (my.user.name, etc.)
│   │   │   ├── workstation.nix     #  → workstation role (sway/portals/pipewire/PAM/...)
│   │   │   ├── server.nix          #  → server role (placeholder)
│   │   │   └── host-nixos.nix      #  → host-nixos (hostname, locale, packages, ...)
│   │   └── hosts/
│   │       ├── wsl.nix             # builds homeConfigurations."clausormann@wsl"
│   │       └── nixos.nix           # builds nixosConfigurations.nixos (+HM submodule)
│   └── nixos/
│       └── _hardware-configurations/
│           └── nixos.nix           # raw hw config (skipped by import-tree via _ prefix)
└── config/                         # plain dotfiles, live-symlinked via mkOutOfStoreSymlink
    ├── nvim/  ghostty/  wezterm/  alacritty/  atuin/  fuzzel/  bat/  starship.toml
```

### Conventions

- Files/dirs prefixed with `_` are skipped by `import-tree`. Used here for
  `_hardware-configurations/` (raw hw, imported explicitly by `host-nixos.nix`).
- The whole `config/` tree is **not** Nix-managed. It's symlinked live into
  `~/.config/` via `config.lib.file.mkOutOfStoreSymlink "${my.repoPath}/..."`
  so edits apply without a rebuild. Tools managed this way: nvim, ghostty,
  wezterm, alacritty, atuin, fuzzel, starship.

## The role taxonomy

| Class         | Role               | Who imports it                                              |
|---------------|--------------------|-------------------------------------------------------------|
| `homeManager` | `base`             | Every HM config (WSL, NixOS HM submodule)                   |
| `homeManager` | `workstation-user` | Hosts that want a graphical desktop (WSL today, NixOS today)|
| `homeManager` | `host-wsl`         | The WSL host only                                           |
| `nixos`       | `base`             | Every NixOS host                                            |
| `nixos`       | `workstation`      | NixOS hosts that want sway (the home machine today)         |
| `nixos`       | `server`           | Placeholder; future Pi/Optiplex                             |
| `nixos`       | `host-nixos`       | The home NixOS box only                                     |

A "tool" file (e.g. `desktop-fuzzel.nix`) does not get its own role — it
contributes *into* an existing role via module-merge. New top-level roles
are only added when you have a host that wants a different mix of tools.

## Custom options (the `my.*` namespace)

Every host must set these. There are no defaults — eval will fail loudly if
something is missing on a new host, by design.

### HM scope (`modules/flake/home/options.nix`)

| Option | Type | Purpose |
|---|---|---|
| `my.repoPath` | `str` | Absolute path to this repo on the host. Read by every module that uses `mkOutOfStoreSymlink`. |
| `my.editor.neovim.extraRuntimePackages` | `listOf package`, default `[]` | Extra packages prepended to the wrapped `nvim` binary's PATH only. For lazy.nvim plugin builds (gcc/gnumake for treesitter parsers, cargo/rustc for blink.cmp) and tools nvim shells out to. |

### NixOS scope (`modules/flake/nixos/options.nix`)

| Option | Type | Purpose |
|---|---|---|
| `my.user.name` | `str` | Primary user account on this NixOS host. Drives both `users.users.<name>` and `home-manager.users.<name>`. |
| `my.repoPath` | `str` | Absolute path to this repo on this NixOS host. Forwarded into the HM submodule by `modules/flake/hosts/nixos.nix`. |
| `my.editor.neovim.extraRuntimePackages` | `listOf package`, default `[]` | Transport option. Forwarded into HM scope; has no NixOS-side semantic effect on its own. |

### Where each host sets them

- WSL — `modules/flake/home/host-wsl.nix`
- NixOS — `modules/flake/nixos/host-nixos.nix`

## The overlay accumulator (option α)

Tools that need an overlay (currently only neovim-nightly) declare it
inline:

```nix
# modules/flake/home/editor-neovim.nix
{ inputs, ... }:
{
  flake.dendritic.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
  ];
  flake.modules.homeManager.workstation-user = { pkgs, ... }: { ... };
}
```

`modules/flake/nixpkgs.nix` declares `flake.dendritic.overlays` as a
list-typed option, accumulates every contribution via module-merge, and
imports `nixpkgs` once with the merged set. Both HM and NixOS configs
consume the resulting `pkgs` via `_module.args.pkgs`. There is no
`overlays/default.nix` — adding an overlay = drop a file under
`modules/flake/home/` (or `nixos/`) that contributes to
`flake.dendritic.overlays`.

## Build & switch flow

### WSL (standalone Home-Manager)

```sh
# Build only:
home-manager build --flake ".#clausormann@wsl"

# Build + activate:
home-manager switch --flake ".#clausormann@wsl"

# Verify (no Nix activation, just eval):
nix flake check
```

#### One-time: enable the nix-community binary cache

Home-Manager on a non-NixOS host cannot rewrite `/etc/nix/nix.conf`. Run
this once per fresh WSL box so neovim-nightly comes down prebuilt:

```sh
nix-env -iA cachix -f https://cachix.org/api/v1/install
sudo $(which cachix) use nix-community
sudo systemctl restart nix-daemon
```

### NixOS

```sh
# Build only:
sudo nixos-rebuild build --flake ".#nixos"

# Build + activate:
sudo nixos-rebuild switch --flake ".#nixos"
```

Home-Manager is wired in via `modules/flake/hosts/nixos.nix` with
`useGlobalPkgs` and `useUserPackages`, so there's no separate
`home-manager switch` on NixOS — the system rebuild covers both.

### Inspecting evaluated config

```sh
# What does HM see for the WSL host?
nix eval --json '.#homeConfigurations."clausormann@wsl".config.my'

# What runtime packages reach the wrapped nvim on NixOS?
nix eval --json \
  '.#nixosConfigurations.nixos.config.home-manager.users.normann.my.editor.neovim.extraRuntimePackages' \
  --apply 'xs: map (p: p.pname or p.name) xs'

# Which version of nvim is wired in (nightly = commit-hash suffix)?
nix eval --raw '.#homeConfigurations."clausormann@wsl".config.programs.neovim.finalPackage.name'
```

## Adding a new tool

1. Drop a new file under `modules/flake/home/<category>-<tool>.nix` (or
   `modules/flake/nixos/<tool>.nix`).
2. Make it contribute to the appropriate role:

   ```nix
   {
     flake.modules.homeManager.workstation-user = { pkgs, config, ... }: {
       home.packages = [ pkgs.<tool> ];
       xdg.configFile."<tool>".source =
         config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/<tool>";
     };
   }
   ```

3. (Optional) If the tool needs an overlay, also contribute to
   `flake.dendritic.overlays`.
4. `nix flake check` — if it passes, the tool is wired into every host
   that imports the role.

## Adding a new HM host

1. Drop `modules/flake/home/host-<name>.nix` setting identity, repoPath,
   and any host-specific quirks (analogous to `host-wsl.nix`).
2. Drop `modules/flake/hosts/<host>.nix` building
   `flake.homeConfigurations."<user>@<host>"` from
   `flake.modules.homeManager.{base, workstation-user, host-<name>}`.
3. Build: `home-manager build --flake ".#<user>@<host>"`.

## Adding a new NixOS host

1. Generate the hardware config on the target machine; place it at
   `modules/nixos/_hardware-configurations/<name>.nix`.
2. Drop `modules/flake/nixos/host-<name>.nix` declaring
   `flake.modules.nixos.host-<name>` with hostname, `my.user.name`,
   `my.repoPath`, `system.stateVersion`, and explicit `imports = [ ../../nixos/_hardware-configurations/<name>.nix ];`.
3. Drop `modules/flake/hosts/<name>.nix` building
   `flake.nixosConfigurations.<name>` (mirror `nixos.nix`), wiring in
   `nixos.{base, workstation or server, host-<name>}` and the HM submodule.
4. `sudo nixos-rebuild switch --flake "<repoPath>#<name>"`.

## Neovim LSP servers

The neovim configuration uses the native `vim.lsp.config()`/`vim.lsp.enable()`
API directly (`config/nvim/lua/lsp/init.lua`) — no `mason.nvim`. Server
binaries come from three places:

- **Nix (`my.editor.neovim.extraRuntimePackages`)**:
  `bash-language-server`, `clang-tools` (clangd), `lua-language-server`.
  Pinned by `flake.lock`; upgrade by bumping nixpkgs.
- **`uvx` (online)**: `ruff`, `ty`. The `cmd` in
  `config/nvim/lua/lsp/servers.lua` launches `uvx ruff server` / `uvx ty
  server`; uv resolves on each invocation, cache-served when version
  matches. Requires network at nvim startup.
- **Manual install**: `tombi` (TOML LSP). `cargo install tombi-lsp`.

## Migration history

This repo was rebuilt from a hybrid (mixed plain-modules + flake-parts)
layout into the strict dendritic pattern across 14 atomic commits
(`C01`–`C14`). Every commit kept `nix flake check` green and both the
WSL HM build and the NixOS toplevel build succeeded after each step.

Headlines:

- C01 — added `flake-parts.flakeModules.modules` import.
- C02 — added `perSystem.checks.nixfmt` formatter gate; reformatted all `.nix`.
- C03 — first leaf migration (ghostty) as proof of pattern.
- C04–C08 — terminals, shells, dev tools, neovim+nightly, desktop split.
- C09 — NixOS base/workstation/host roles; `hardware-configuration.nix` moved.
- C10 — WSL host module.
- C11 — deleted legacy aggregators (`modules/{home,nixos}/default.nix`,
  `home-manager.nix`, `home-modules.nix`, `nixos-modules.nix`,
  `nixos-configurations.nix`, `overlays/`, `hosts/`).
- C13 — `server` role placeholder.
- C14 — this README.

`specialArgs` is no longer used anywhere; tools and hosts read from
`config.flake.modules.<class>.<role>` exclusively.

## Notes

- `flake.lock` is intentionally kept stable — newer nixpkgs revisions have
  triggered an opencode segfault. Bump deliberately, not opportunistically.
- Repository is private. The atuin sync URL in `config/atuin/config.toml`
  and the WSL pip-token shim in `modules/flake/home/host-wsl.nix` (which
  reads `~/pip-token-mftus` at runtime, never embedding the token in the
  store) are the only borderline-secret items; both are flagged with
  comments.
