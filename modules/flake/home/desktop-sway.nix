# Sway window manager — workstation-user role.
#
# Keybinds mirror the archived i3 config (archive/x11) with Mod1 (Alt) as the
# main modifier, Mod4+l for swaylock.
{
  flake.modules.homeManager.workstation-user =
    {
      pkgs,
      lib,
      ...
    }:
    let
      mod = "Mod1";
    in
    {
      wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        config = {
          modifier = mod;
          terminal = "ghostty";
          menu = "fuzzel";

          # Dual layout: dk on the laptop's built-in keyboard, us on the
          # programmable mechanical splits. Mod4+Space toggles between them.
          # (Earlier `grp:alt_shift_toggle` hijacked Mod1+Shift+<num> before
          # sway ever saw it, breaking move-container-to-workspace.)
          input."type:keyboard" = {
            xkb_layout = "dk,us";
            xkb_variant = "nodeadkeys,intl";
            xkb_options = "grp:win_space_toggle";
          };

          # Solid color until the swww-rotate timer fires (30s after boot).
          # Tomorrow Night background.
          output."*".bg = "#282A2E solid_color";

          gaps.inner = 8;
          window.border = 3;
          window.titlebar = false;

          # waybar handles the bar; suppress sway's built-in.
          bars = [ ];

          keybindings = lib.mkOptionDefault {
            # Launchers
            "${mod}+Return" = "exec ghostty";
            "${mod}+d" = "exec fuzzel";
            "${mod}+Shift+q" = "kill";

            # Focus (h/j/k/l + arrow keys)
            "${mod}+h" = "focus left";
            "${mod}+j" = "focus down";
            "${mod}+k" = "focus up";
            "${mod}+l" = "focus right";
            "${mod}+Left" = "focus left";
            "${mod}+Down" = "focus down";
            "${mod}+Up" = "focus up";
            "${mod}+Right" = "focus right";

            # Move (h/j/k/l + arrow keys)
            "${mod}+Shift+h" = "move left";
            "${mod}+Shift+j" = "move down";
            "${mod}+Shift+k" = "move up";
            "${mod}+Shift+l" = "move right";
            "${mod}+Shift+Left" = "move left";
            "${mod}+Shift+Down" = "move down";
            "${mod}+Shift+Up" = "move up";
            "${mod}+Shift+Right" = "move right";

            # Layout
            "${mod}+b" = "split h";
            "${mod}+v" = "split v";
            "${mod}+f" = "fullscreen toggle";
            "${mod}+s" = "layout stacking";
            "${mod}+w" = "layout tabbed";
            "${mod}+e" = "layout toggle split";
            "${mod}+Shift+space" = "floating toggle";
            "${mod}+space" = "focus mode_toggle";
            "${mod}+a" = "focus parent";

            # Workspaces
            "${mod}+1" = "workspace number 1";
            "${mod}+2" = "workspace number 2";
            "${mod}+3" = "workspace number 3";
            "${mod}+4" = "workspace number 4";
            "${mod}+5" = "workspace number 5";
            "${mod}+6" = "workspace number 6";
            "${mod}+7" = "workspace number 7";
            "${mod}+8" = "workspace number 8";
            "${mod}+9" = "workspace number 9";
            "${mod}+0" = "workspace number 10";

            "${mod}+Shift+1" = "move container to workspace number 1";
            "${mod}+Shift+2" = "move container to workspace number 2";
            "${mod}+Shift+3" = "move container to workspace number 3";
            "${mod}+Shift+4" = "move container to workspace number 4";
            "${mod}+Shift+5" = "move container to workspace number 5";
            "${mod}+Shift+6" = "move container to workspace number 6";
            "${mod}+Shift+7" = "move container to workspace number 7";
            "${mod}+Shift+8" = "move container to workspace number 8";
            "${mod}+Shift+9" = "move container to workspace number 9";
            "${mod}+Shift+0" = "move container to workspace number 10";

            # Move container AND follow it (chained command via `;`).
            "${mod}+Ctrl+1" = "move container to workspace number 1; workspace number 1";
            "${mod}+Ctrl+2" = "move container to workspace number 2; workspace number 2";
            "${mod}+Ctrl+3" = "move container to workspace number 3; workspace number 3";
            "${mod}+Ctrl+4" = "move container to workspace number 4; workspace number 4";
            "${mod}+Ctrl+5" = "move container to workspace number 5; workspace number 5";
            "${mod}+Ctrl+6" = "move container to workspace number 6; workspace number 6";
            "${mod}+Ctrl+7" = "move container to workspace number 7; workspace number 7";
            "${mod}+Ctrl+8" = "move container to workspace number 8; workspace number 8";
            "${mod}+Ctrl+9" = "move container to workspace number 9; workspace number 9";
            "${mod}+Ctrl+0" = "move container to workspace number 10; workspace number 10";

            # Workspace placement
            "${mod}+n" = "move workspace to output left";

            # Session
            "${mod}+Shift+c" = "reload";
            "${mod}+Shift+r" = "reload"; # sway has no in-place restart; reload is closest
            "${mod}+Shift+e" = "exec swaynag -t warning -m 'Exit sway?' -B 'Yes, exit' 'swaymsg exit'";
            "${mod}+r" = "mode resize";

            # Lock (Super+L, preserved from i3)
            "Mod4+l" = "exec swaylock -f";

            # Media (pipewire-native via wpctl)
            "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
            "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

            # Brightness
            "XF86MonBrightnessDown" = "exec brightnessctl s 5%-";
            "XF86MonBrightnessUp" = "exec brightnessctl s 5%+";

            # Screenshot (region → clipboard)
            "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
          };

          modes.resize = {
            h = "resize shrink width 10 px or 10 ppt";
            j = "resize grow height 10 px or 10 ppt";
            k = "resize shrink height 10 px or 10 ppt";
            l = "resize grow width 10 px or 10 ppt";
            Left = "resize shrink width 10 px or 10 ppt";
            Down = "resize grow height 10 px or 10 ppt";
            Up = "resize shrink height 10 px or 10 ppt";
            Right = "resize grow width 10 px or 10 ppt";
            Return = "mode default";
            Escape = "mode default";
            "${mod}+r" = "mode default";
          };

          startup = [
            # swww-daemon must be running before swww-rotate fires.
            { command = "${pkgs.awww}/bin/swww-daemon"; }
            # NetworkManager tray applet (waybar's "tray" module hosts it).
            { command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"; }
          ];
        };
      };

      home.packages = with pkgs; [
        grim
        slurp
        wl-clipboard
        brightnessctl
        networkmanagerapplet
      ];
    };
}
