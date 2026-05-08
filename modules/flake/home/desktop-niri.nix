# Niri scrollable-tiling Wayland compositor — workstation-niri-user HM role.
#
# Imports the upstream niri-flake HM module (sodiboo/niri-flake) for typed
# settings, then declares everything as Nix attrs. The package field points
# at the wrapped niri exposed by `modules/flake/nixos/desktop-niri.nix` so
# the HM-managed niri shares the same hermetic-PATH wrapper as the system
# one (no PATH duplication, no ambiguity about which niri runs).
#
# Keybinds mirror the sway config (modules/flake/home/desktop-sway.nix):
# Alt as the mod key, Alt+Return for ghostty, Alt+d for the launcher,
# Alt+Shift+1..0 to move the window to a workspace, Alt+Ctrl+1..0 to
# move-and-follow. Niri's column model differs from sway's tiling tree:
# focus h/l move between columns (left/right), focus j/k move within the
# column (up/down). Move h/l reorder columns; move j/k reorder windows
# within a column. Sway's "split h/v" / "layout stacking/tabbed" have no
# direct niri equivalent and are intentionally unbound here.
{ inputs, ... }:
{
  flake.modules.homeManager.workstation-niri-user =
    {
      pkgs,
      config,
      ...
    }:
    {
      # No `imports` here for niri-flake's HM module: the NixOS-side
      # `inputs.niri-flake.nixosModules.niri` injects `homeModules.config`
      # via `home-manager.sharedModules`, and re-importing it on our
      # side triggers a duplicate-declaration error on
      # `programs.niri.finalConfig`. Settings below evaluate against
      # the typed schema provided by that injected module.

      programs.niri = {
        settings = {
          input.keyboard = {
            xkb = {
              layout = "dk,us";
              variant = "nodeadkeys,intl";
              options = "grp:win_space_toggle";
            };
          };

          input.touchpad = {
            tap = true;
            natural-scroll = true;
          };

          # Use Alt as the niri mod key, matching the sway Mod1 setup.
          input.mod-key = "Alt";

          layout = {
            gaps = 8;
            border = {
              enable = true;
              width = 3;
            };
            focus-ring.enable = false;
          };

          # Spawn Noctalia (and any helpers) at session start. Noctalia
          # provides bar, launcher, notifications, OSD, lock screen,
          # wallpaper management — replacing waybar/fuzzel/swaylock/swayidle
          # /swww from the sway stack.
          spawn-at-startup = [
            { command = [ "noctalia-shell" ]; }
          ];

          # Sway-style keybinds. Niri uses `Mod` as the configured mod-key
          # (Alt here), and binds are a flat attrset keyed by combo.
          binds = with config.lib.niri.actions; {
            # Launchers ------------------------------------------------------
            "Mod+Return".action = spawn "ghostty";
            # Mod+d → Noctalia launcher.
            "Mod+d".action = spawn "noctalia-shell" "ipc" "call" "launcher" "toggle";
            "Mod+Shift+q".action = close-window;

            # Focus (h/j/k/l + arrow keys) -----------------------------------
            # In niri's column model: h/l move between columns, j/k move
            # between windows within a column.
            "Mod+h".action = focus-column-left;
            "Mod+l".action = focus-column-right;
            "Mod+j".action = focus-window-or-workspace-down;
            "Mod+k".action = focus-window-or-workspace-up;
            "Mod+Left".action = focus-column-left;
            "Mod+Right".action = focus-column-right;
            "Mod+Down".action = focus-window-or-workspace-down;
            "Mod+Up".action = focus-window-or-workspace-up;

            # Move (h/j/k/l + arrow keys) ------------------------------------
            "Mod+Shift+h".action = move-column-left;
            "Mod+Shift+l".action = move-column-right;
            "Mod+Shift+j".action = move-window-down-or-to-workspace-down;
            "Mod+Shift+k".action = move-window-up-or-to-workspace-up;
            "Mod+Shift+Left".action = move-column-left;
            "Mod+Shift+Right".action = move-column-right;
            "Mod+Shift+Down".action = move-window-down-or-to-workspace-down;
            "Mod+Shift+Up".action = move-window-up-or-to-workspace-up;

            # Layout ---------------------------------------------------------
            "Mod+f".action = maximize-column;
            "Mod+Shift+f".action = fullscreen-window;
            "Mod+Shift+space".action = toggle-window-floating;
            "Mod+space".action = switch-focus-between-floating-and-tiling;
            # Niri analogues of sway split/layout: column-width and consume
            # / expel reshape the layout.
            "Mod+r".action = switch-preset-column-width;
            "Mod+comma".action = consume-window-into-column;
            "Mod+period".action = expel-window-from-column;

            # Workspaces (1..10) — niri workspaces are dynamic per-monitor.
            "Mod+1".action = focus-workspace 1;
            "Mod+2".action = focus-workspace 2;
            "Mod+3".action = focus-workspace 3;
            "Mod+4".action = focus-workspace 4;
            "Mod+5".action = focus-workspace 5;
            "Mod+6".action = focus-workspace 6;
            "Mod+7".action = focus-workspace 7;
            "Mod+8".action = focus-workspace 8;
            "Mod+9".action = focus-workspace 9;
            "Mod+0".action = focus-workspace 10;

            # Move-window-to-workspace, no follow.
            "Mod+Shift+1".action.move-window-to-workspace = 1;
            "Mod+Shift+2".action.move-window-to-workspace = 2;
            "Mod+Shift+3".action.move-window-to-workspace = 3;
            "Mod+Shift+4".action.move-window-to-workspace = 4;
            "Mod+Shift+5".action.move-window-to-workspace = 5;
            "Mod+Shift+6".action.move-window-to-workspace = 6;
            "Mod+Shift+7".action.move-window-to-workspace = 7;
            "Mod+Shift+8".action.move-window-to-workspace = 8;
            "Mod+Shift+9".action.move-window-to-workspace = 9;
            "Mod+Shift+0".action.move-window-to-workspace = 10;

            # Move-and-follow (Mod+Ctrl+N) — niri's `move-window-to-workspace`
            # already focuses the destination workspace by default, which is
            # the same behavior as sway's chained "move … ; workspace …".
            # Bind these the same as Mod+Shift+N for muscle memory.
            "Mod+Ctrl+1".action.move-window-to-workspace = 1;
            "Mod+Ctrl+2".action.move-window-to-workspace = 2;
            "Mod+Ctrl+3".action.move-window-to-workspace = 3;
            "Mod+Ctrl+4".action.move-window-to-workspace = 4;
            "Mod+Ctrl+5".action.move-window-to-workspace = 5;
            "Mod+Ctrl+6".action.move-window-to-workspace = 6;
            "Mod+Ctrl+7".action.move-window-to-workspace = 7;
            "Mod+Ctrl+8".action.move-window-to-workspace = 8;
            "Mod+Ctrl+9".action.move-window-to-workspace = 9;
            "Mod+Ctrl+0".action.move-window-to-workspace = 10;

            # Move workspace between monitors --------------------------------
            "Mod+n".action = move-workspace-to-monitor-left;

            # Session --------------------------------------------------------
            "Mod+Shift+c".action = quit;
            "Mod+Shift+r".action = quit;
            "Mod+Shift+e".action = quit { skip-confirmation = true; };

            # Lock screen — Mod4+l preserved from sway/i3 muscle memory.
            # Noctalia provides the lock screen.
            "Super+l".action = spawn "noctalia-shell" "ipc" "call" "lockScreen" "toggle";

            # Media keys (pipewire-native via wpctl) -------------------------
            "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+";
            "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
            "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
            "XF86AudioMicMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";

            # Brightness -----------------------------------------------------
            "XF86MonBrightnessDown".action = spawn "brightnessctl" "s" "5%-";
            "XF86MonBrightnessUp".action = spawn "brightnessctl" "s" "5%+";

            # Screenshot — niri ships its own screenshot UI. These actions
            # are flag-style (no args), expressed via the `.action.<name>`
            # form because niri-flake's `lib.niri.actions` doesn't expose
            # screenshot variants (they're handled by the underlying KDL
            # leaf encoding).
            "Print".action.screenshot = [ ];
            "Shift+Print".action.screenshot-screen = [ ];
            "Ctrl+Print".action.screenshot-window = [ ];
          };
        };
      };

      # Userland helpers that niri keybinds and Noctalia shell out to.
      # The compositor binary itself is wrapped with a hermetic PATH (see
      # modules/flake/nixos/desktop-niri.nix → niri-wrapped); these are
      # general user-facing CLIs.
      home.packages = with pkgs; [
        grim
        slurp
        wl-clipboard
        brightnessctl
        playerctl
        pamixer
      ];
    };
}
