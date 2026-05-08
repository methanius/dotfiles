# Waybar status bar — workstation-user role.
#
# Tomorrow Night palette, JetBrainsMonoNL Nerd Font 11pt, top position.
{
  flake.modules.homeManager.workstation-user =
    { ... }:
    {
      programs.waybar = {
        enable = true;
        # Run as a systemd user unit bound to graphical-session.target so waybar
        # comes up automatically when sway starts and goes down with it.
        systemd = {
          enable = true;
          targets = [ "sway-session.target" ];
        };
        settings.mainBar = {
          layer = "bottom";
          position = "top";
          height = 28;
          spacing = 6;

          modules-left = [
            "sway/workspaces"
            "sway/window"
          ];
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
    };
}
