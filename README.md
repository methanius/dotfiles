# dotfiles

Personal Nix flake managing both a standalone Home-Manager install on WSL
and a full NixOS system + Home-Manager on a home machine. Built strictly on
the [dendritic pattern](https://github.com/mightyiam/dendritic) using
[`flake-parts`](https://flake.parts/),
[`vic/import-tree`](https://github.com/vic/import-tree), and the
[`flake-parts.flakeModules.modules`](https://flake.parts/options/flake-parts-modules.html)
namespace.

## Acknowledgements

The dendritic pattern is the work of **[Shahar "mightyiam" Dawn
Or](https://github.com/mightyiam)**, who designed it, named it, wrote the
canonical reference implementation, and continues to evolve it. This repo
is a straightforward application of his pattern to a personal
WSL+NixOS setup — none of the underlying ideas originate here. Credit also
to **[Victor Borja (vic)](https://github.com/vic)** for `import-tree`,
which is what makes the "drop a file, it's wired in" ergonomics possible,
and to **[Vimjoyer](https://www.youtube.com/@vimjoyer)** whose video
walkthrough is the easiest on-ramp to the pattern for newcomers.

## Required reading

If you've not seen the dendritic pattern before, read/watch these before
making changes — the structure here will look strange otherwise:

1. **[mightyiam/dendritic](https://github.com/mightyiam/dendritic)** —
   the canonical reference implementation by the pattern's author.
   This is the source of truth.
2. **[dendritic.oeiuwq.com](https://dendritic.oeiuwq.com/)** —
   high-level prose intro to the pattern (companion site to the repo).
3. **[Vimjoyer — "Dendritic Nix configurations" on
   YouTube](https://www.youtube.com/watch?v=cZjOzOHb2ow)** —
   ~10-minute video walkthrough; best first-time intro.
4. **[flake-parts modules
   namespace](https://flake.parts/options/flake-parts-modules.html)** —
   reference for `flake.modules.<class>.<name>`, which is the mechanism
   every file in this repo uses.
5. **[vic/import-tree](https://github.com/vic/import-tree)** —
   auto-discovery rules (`.nix` files only, paths containing `/_` are
   skipped).
6. **[flake.parts](https://flake.parts/)** — general flake-parts docs;
   useful for `perSystem`, `mkFlake`, options.

## Philosophy

The single design rule is: **every piece of configuration is a flake-parts
module that contributes into a named role via module-merge, and the role is
the only thing a host imports.** No aggregator files, no `default.nix`
re-exporters, no `imports = [ ./foo.nix ./bar.nix ./baz.nix ]` lists,
no plain Home-Manager or NixOS module trees living next to the flake-parts
ones.

What this buys:

- **Adding a tool is a one-file operation.** Drop a file under
  `modules/flake/`, make it write into the right role, done. No other file
  changes — `import-tree` discovers it, module-merge composes it. Removing a
  tool is a one-file delete.
- **Hosts are tiny.** `modules/flake/hosts/<host>.nix` does nothing but pick
  which roles to compose. No tool list to maintain per host.
- **Nothing is positional.** Because everything is module-merged, file order
  doesn't matter, options can be defined and used in either order, and any
  number of files can contribute to the same role.
- **Type safety throughout.** Custom cross-module data flows through
  options declared in `options.nix` files — `mkOption { type = ...; }` —
  not via `specialArgs`, not via free-form attrsets. Wrong type = eval
  error pointing at the file that violated it.
- **One source of truth per concern.** `nixpkgs` is instantiated exactly
  once via the overlay accumulator (option α). `pkgs` is the same instance
  on the HM and NixOS sides of a single host. Overlays are declared next to
  the tools that need them, never in a separate registry.
- **The flake entry is dumb.** `flake.nix` is six meaningful lines. There is
  no logic at the top level — all behavior emerges from the module tree.
- **Every commit is green.** `nix flake check` runs `nixfmt` as a gate;
  every commit also builds the WSL HM activation package and the NixOS
  toplevel. Atomic, reversible commits — no half-migrated states allowed.

What this costs:

- **Mental overhead up front.** You must internalize "module-merge" and
  "role" before the layout reads naturally. A first-time reader looking at
  ten files all declaring `flake.modules.homeManager.workstation-user = ...`
  needs to know those merge into one composite module.
- **No drive-by edits.** "Just add a package" still means picking the right
  role, the right file (or making a new one), and verifying with the build
  gates. The pattern doesn't reward shortcuts.

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
│   │   │   ├── browser-firefox.nix #  → workstation-user (NUR addons)
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
- Filenames follow `<category>-<tool>.nix`. Categories in use:
  `shell-`, `terminal-`, `editor-`, `browser-`, `desktop-`, `dev`, `host-`.
  Add a new category only when it's a real conceptual axis, not for
  one-offs.

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

### Picking the right role

Decision tree for a new file:

- **Is it user-level config (dotfiles, HM programs)?** → `homeManager.*`.
  - Always wanted on every host (CLI tools, shell, git, etc.)? → `base`.
  - Only on graphical hosts (sway, terminal emulators, browser)? →
    `workstation-user`.
  - Only on one specific host? → `host-<name>`.
- **Is it system-level config (services, kernel, drivers, fs)?** →
  `nixos.*`.
  - Wanted on every NixOS box? → `base`.
  - Only on graphical NixOS boxes? → `workstation`.
  - Only on a server? → `server`.
  - Only on one specific box? → `host-<name>`.

If you find yourself wanting a contribution to "everything except X", you
probably want a new role, not conditional logic in an existing one.

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

### Adding a new `my.*` option

1. Decide scope: HM-only, NixOS-only, or both?
2. Declare it in the corresponding `options.nix` with a precise type
   (prefer `lib.types.package`, `listOf package`, `enum [ ... ]`,
   `submodule { options = ...; }` — avoid `attrs` / `unspecified`).
3. Set it in every host that needs it (either `host-*.nix` file).
4. Read it via `config.my.<path>` in the consuming tool module.
5. If it crosses the NixOS→HM boundary, forward it explicitly in
   `modules/flake/hosts/<host>.nix` (see how `extraRuntimePackages` is
   forwarded today).

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

---

# Adding things — the cookbook

Every recipe below has the same shape: pick the role, drop a file, run the
gates. The differences are which knobs you turn inside the file. **Always
start a new jj change before editing** (`jj new -m "<scope>: <summary>"`)
and run all three gates after:

```sh
nix flake check                                                              # nixfmt + eval
nix build .#homeConfigurations."clausormann@wsl".activationPackage --no-link # WSL HM
nix build .#nixosConfigurations.nixos.config.system.build.toplevel --no-link # NixOS toplevel
```

## 1. Add a plain CLI package (no config, just `home.packages`)

Use this when the tool has no HM module and no config files — `ripgrep`,
`jq`, a one-off CLI utility.

If it logically fits in an existing aggregator (`programs.nix` for shell
add-ons like fzf/atuin, `dev.nix` for dev toolchains), append to that
file's `home.packages` list. Otherwise drop a new file:

```nix
# modules/flake/home/<category>-<tool>.nix
{
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = [ pkgs.<tool> ];
  };
}
```

Use `base` for ubiquitous CLIs, `workstation-user` for graphical-only
tools.

## 2. Add a Home-Manager–managed program (HM has a `programs.<x>` module)

Use this when HM ships first-class support — `programs.git`,
`programs.fzf`, `programs.firefox`. Prefer the HM module over rolling your
own config, you get type-checking and idiomatic option names for free.

```nix
# modules/flake/home/<category>-<tool>.nix
{
  flake.modules.homeManager.base = { pkgs, ... }: {
    programs.<tool> = {
      enable = true;
      settings = { ... };
    };
  };
}
```

If the tool *also* has a config directory you want to live-edit, use the
hybrid pattern: enable the program, then symlink its config dir:

```nix
{ flake.modules.homeManager.base = { pkgs, config, ... }: {
    programs.<tool>.enable = true;
    xdg.configFile."<tool>".source =
      config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/<tool>";
  };
}
```

Trade-off: enabling the HM program *and* symlinking its config dir can
collide if HM tries to write specific files inside that directory. Solution
is the same as in `editor-neovim.nix`: `xdg.configFile."<tool>/foo".enable
= lib.mkForce false;` for any specific file HM insists on managing.

## 3. Add a tool that needs a wrapped binary (PATH injection / runtime env)

Use this when the tool needs auxiliary binaries on its `PATH` *only when it
runs* — not in your shell — and Nix's wrapping machinery can do it. The
canonical case is neovim plugins that shell out to compilers.

Pattern: declare a typed option for the extras, set it from the host or
from another tool module, read it inside the wrapper. See
`modules/flake/home/options.nix` for `my.editor.neovim.extraRuntimePackages`
and `modules/flake/home/editor-neovim.nix` for how it feeds
`programs.neovim.extraPackages`.

For a brand-new tool with the same need, mirror that exactly: option in
`options.nix`, host or tool sets it, wrapper consumes it.

## 4. Add a tool that needs an overlay (nightly, fork, custom version)

Same as adding a tool, plus contribute to `flake.dendritic.overlays`:

```nix
# modules/flake/home/<category>-<tool>.nix
{ inputs, ... }:
{
  flake.dendritic.overlays = [
    inputs.<input>.overlays.default
  ];
  flake.modules.homeManager.workstation-user = { pkgs, ... }: {
    home.packages = [ pkgs.<tool> ];   # picked up from overlay
  };
}
```

If `inputs.<input>` doesn't exist yet, add it to `flake.nix` first
(remember `inputs.nixpkgs.follows = "nixpkgs";` to keep `pkgs` unified).

## 5. Add a Firefox/browser extension via NUR

Both Firefox addons and other niche packages live in
[NUR](https://github.com/nix-community/NUR). NUR is wired in as a flake
input (`flake.nix`) and consumed in-module:

```nix
# modules/flake/home/browser-firefox.nix (existing)
{ inputs, ... }:
{
  flake.modules.homeManager.workstation-user = { pkgs, ... }:
    let
      addons = inputs.nur.legacyPackages.${pkgs.system}.repos.rycee.firefox-addons;
    in
    {
      programs.firefox.profiles.default.extensions.packages = with addons; [
        proton-pass tridactyl ublock-origin sponsorblock
      ];
    };
}
```

To add another addon: append the attr name (browse
[NUR-combined](https://nix-community.github.io/NUR-combined/) to find what's
packaged). To add NUR consumption to a *different* tool module, repeat the
`inputs.nur.legacyPackages.${pkgs.system}` line locally — NUR is
intentionally not a global overlay because most modules don't need it.

> **Don't** use the legacy `import inputs.nur { inherit pkgs; }` form.
> Some sub-repos (including `rycee`) do `<nixpkgs>` channel lookups
> internally, which fails under pure flake evaluation. The
> `legacyPackages.${system}` flake attribute is the pure-eval-safe route
> and is what NUR's flake exposes for exactly this purpose.

## 6. Add a system service / kernel option / hardware tweak (NixOS)

NixOS-side changes go under `modules/flake/nixos/`. Pick the role using
the decision tree above.

```nix
# modules/flake/nixos/<tool>.nix
{
  flake.modules.nixos.workstation = { pkgs, ... }: {
    services.<thing>.enable = true;
    environment.systemPackages = [ pkgs.<tool> ];
  };
}
```

If the tool needs *both* a NixOS-side service and an HM-side user config
(e.g. pipewire + a user mixer config), drop two files: one under
`modules/flake/nixos/`, one under `modules/flake/home/`. They're
independent contributions; module-merge wires them up by role membership,
not file proximity.

## 7. Add a new shell

Shells are HM `programs.<shell>` modules — same shape as recipe 2, plus
two extras:

- The new shell goes in `home.users.<u>.shell` or
  `users.users.<u>.shell` only if you want to set it as the *default*
  login shell on NixOS. That's a NixOS-side decision; put it in
  `modules/flake/nixos/host-<name>.nix` (or wherever the user is
  declared), not in the shell's HM module.
- If you want shared shell snippets (aliases, env), they live in the
  shell's own module — there is no global "shell" abstraction here. Each
  shell module owns its config end-to-end.

```nix
# modules/flake/home/shell-<name>.nix
{
  flake.modules.homeManager.base = { ... }: {
    programs.<name> = {
      enable = true;
      shellAliases = { ... };
      initExtra = ''...'';
    };
  };
}
```

If you want it everywhere, put it in `base`. If only on graphical hosts,
`workstation-user`.

## 8. Add a new compositor / desktop environment

Same pattern as the existing `desktop-*` files. Two halves:

**HM half** (the user-side config: keybinds, output layout, status bar,
launcher):

```nix
# modules/flake/home/desktop-<wm>.nix
{
  flake.modules.homeManager.workstation-user = { pkgs, config, ... }: {
    wayland.windowManager.<wm>.enable = true;   # or programs.<wm>, etc.
    xdg.configFile."<wm>".source =
      config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/<wm>";
  };
}
```

**NixOS half** (the system-side: portals, polkit, seat, audio, login
manager). On graphical NixOS boxes this lives in
`modules/flake/nixos/workstation.nix` today (see how sway is wired:
`programs.sway.enable`, `xdg.portal`, `services.pipewire`,
`security.polkit`, etc.). Either extend that file for a closely related
WM (sway → hyprland share most plumbing) or create
`modules/flake/nixos/desktop-<wm>.nix` that contributes to the
`workstation` role for a substantially different stack.

If the new WM is *replacing* sway on a host rather than coexisting,
either make the existing `workstation` role parametric (an option like
`my.desktop.compositor`) or split into two roles
(`workstation-sway`, `workstation-hyprland`) and have hosts pick.

## 9. Add a new role

You need a new role when you have (or are about to have) a host that wants
a *different mix* of tools than any existing role gives. Example: a
headless-but-graphical kiosk that wants the desktop stack but not the dev
toolchain.

Steps:

1. Document the role in the **Role taxonomy** table above.
2. Pick the class (`homeManager` or `nixos`).
3. Existing tool files start contributing to it where appropriate
   (most tools end up in multiple roles, e.g. firefox is in
   `workstation-user`, not in `kiosk`).
4. The host file (`modules/flake/hosts/<host>.nix`) imports the new role
   into its `modules` list.

There is no "create role" ceremony — a role exists as soon as a file
writes to `flake.modules.<class>.<rolename>` and a host imports it.

## 10. Add a new HM host

1. Drop `modules/flake/home/host-<name>.nix` setting identity, repoPath,
   and any host-specific quirks (analogous to `host-wsl.nix`).
2. Drop `modules/flake/hosts/<host>.nix` building
   `flake.homeConfigurations."<user>@<host>"` from
   `flake.modules.homeManager.{base, workstation-user, host-<name>}`.
3. Build: `home-manager build --flake ".#<user>@<host>"`.

## 11. Add a new NixOS host

1. Generate the hardware config on the target machine; place it at
   `modules/nixos/_hardware-configurations/<name>.nix`.
2. Drop `modules/flake/nixos/host-<name>.nix` declaring
   `flake.modules.nixos.host-<name>` with hostname, `my.user.name`,
   `my.repoPath`, `system.stateVersion`, and explicit
   `imports = [ ../../nixos/_hardware-configurations/<name>.nix ];`.
3. Drop `modules/flake/hosts/<name>.nix` building
   `flake.nixosConfigurations.<name>` (mirror `nixos.nix`), wiring in
   `nixos.{base, workstation or server, host-<name>}` and the HM submodule.
4. `sudo nixos-rebuild switch --flake "<repoPath>#<name>"`.

---

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
layout into the strict dendritic pattern across atomic commits
(`C01`–`C15`). Every commit kept `nix flake check` green and both the
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
- C14 — README rewritten.
- C15 — Firefox via NUR (Proton Pass, Tridactyl, uBlock Origin,
  SponsorBlock); `nur` flake input added; `browser-firefox.nix` introduced
  alongside the `browser-` filename category.

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
