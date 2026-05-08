# Sway desktop bundle (Wayland). Opt-in per host: this module is *not* in
# modules/home/default.nix's imports, it's pulled in for graphical hosts via
# modules/nixos/home-manager.nix's `self.homeModules.desktop` line.
#
# Keybinds mirror the archived i3 config (archive/x11) with Mod1 (Alt) as the
# main modifier, Mod4+l for swaylock. Wallpaper rotation is BYO: drop images
# into ~/Pictures/wallpapers and the systemd user timer below picks one at
# random every 15 min via swww.
{
  pkgs,
  config,
  lib,
  ...
}: let
  mod = "Mod1";
  wallpaperDir = "${config.home.homeDirectory}/Pictures/wallpapers";
  rotateScript = pkgs.writeShellScript "swww-rotate" ''
    set -eu
    dir="${wallpaperDir}"
    [ -d "$dir" ] || exit 0
    pick=$(${pkgs.findutils}/bin/find "$dir" -type f \
      \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
      | ${pkgs.coreutils}/bin/shuf -n1)
    [ -n "$pick" ] || exit 0
    ${pkgs.awww}/bin/swww img "$pick" \
      --transition-type random \
      --transition-duration 1
  '';
in {
  home.packages = with pkgs; [
    fuzzel
    awww
    grim
    slurp
    wl-clipboard
    brightnessctl
    networkmanagerapplet
  ];

  xdg.configFile."fuzzel/fuzzel.ini".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.repoPath}/config/fuzzel/fuzzel.ini";

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
      bars = [];

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
        {command = "${pkgs.awww}/bin/swww-daemon";}
        # NetworkManager tray applet (waybar's "tray" module hosts it).
        {command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";}
      ];
    };
  };

  programs.waybar = {
    enable = true;
    # Run as a systemd user unit bound to graphical-session.target so waybar
    # comes up automatically when sway starts and goes down with it.
    systemd = {
      enable = true;
      targets = ["sway-session.target"];
    };
    settings.mainBar = {
      layer = "bottom";
      position = "top";
      height = 28;
      spacing = 6;

      modules-left = ["sway/workspaces" "sway/window"];
      modules-right = [
        "tray"
        "pulseaudio"
        "network"
        "memory"
        "cpu"
        "battery"
        "clock"
      ];

      "sway/workspaces" = {
        disable-scroll = false;
        all-outputs = false;
        format = "{name}";
      };

      "sway/window" = {
        max-length = 60;
      };

      tray = {
        spacing = 8;
      };

      pulseaudio = {
        format = "VOL {volume}%";
        format-muted = "muted";
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      network = {
        format-wifi = "{essid}";
        format-ethernet = "{ifname} {ipaddr}";
        format-disconnected = "{ifname} disconnected";
        on-click = "nm-connection-editor";
        tooltip-format = "{ifname}: {ipaddr}";
      };

      memory = {
        interval = 2;
        format = "RAM {percentage}%";
      };

      cpu = {
        interval = 2;
        format = "CPU {usage}%";
      };

      battery = {
        bat = "BAT0";
        interval = 30;
        format = "{capacity}%";
        format-charging = "⚡{capacity}%";
        format-full = "⚡";
        states = {
          warning = 30;
          critical = 15;
        };
        tooltip-format = "{timeTo}";
      };

      clock = {
        format = "{:%H:%M}";
        tooltip-format = "{:%Y-%m-%d %H:%M:%S}";
      };
    };

    # Tomorrow Night palette, faithful to the archived polybar config:
    #   bg #282A2E   bg-alt #373B41   fg #C5C8C6
    #   primary #F0C674 (yellow)   secondary #8ABEB7 (cyan)
    #   alert #A54242 (red)        disabled #707880
    style = ''
      * {
        font-family: "JetBrainsMonoNL Nerd Font";
        font-size: 11pt;
        min-height: 0;
      }

      window#waybar {
        background: #282A2E;
        color: #C5C8C6;
      }

      #workspaces button {
        padding: 0 8px;
        color: #C5C8C6;
        background: transparent;
        border-bottom: 2px solid transparent;
      }

      #workspaces button.focused,
      #workspaces button.active {
        background: #373B41;
        border-bottom: 2px solid #F0C674;
      }

      #workspaces button.urgent {
        background: #A54242;
        color: #C5C8C6;
      }

      #window {
        padding: 0 8px;
        color: #C5C8C6;
      }

      #tray,
      #pulseaudio,
      #network,
      #memory,
      #cpu,
      #battery,
      #clock {
        padding: 0 8px;
        color: #C5C8C6;
      }

      #pulseaudio {
        color: #F0C674;
      }
      #network {
        color: #8ABEB7;
      }
      #clock {
        color: #F0C674;
      }
      #battery.warning {
        color: #F0C674;
      }
      #battery.critical {
        color: #A54242;
      }

      tooltip {
        background: #373B41;
        color: #C5C8C6;
        border: 1px solid #707880;
      }
    '';
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      ignore-empty-password = true;
      show-failed-attempts = true;
    };
  };

  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -f";
      lock = "${pkgs.swaylock}/bin/swaylock -f";
    };
    timeouts = [
      {
        timeout = 600;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 900;
        command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
        resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
      }
    ];
  };

  # Wallpaper rotation: pick a random image from ~/Pictures/wallpapers and
  # set it via swww every 15 min. BYO directory — this is intentional so the
  # repo stays free of large binary blobs. If the directory is missing or
  # empty the script no-ops cleanly.
  systemd.user.services.swww-rotate = {
    Unit = {
      Description = "Rotate desktop wallpaper via swww";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${rotateScript}";
    };
  };

  systemd.user.timers.swww-rotate = {
    Unit = {
      Description = "Rotate desktop wallpaper every 15 minutes";
      PartOf = ["graphical-session.target"];
    };
    Timer = {
      OnBootSec = "30s";
      OnUnitActiveSec = "15min";
      Unit = "swww-rotate.service";
    };
    Install.WantedBy = ["timers.target"];
  };
}
