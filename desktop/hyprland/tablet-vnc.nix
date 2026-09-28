{ config, pkgs, ... }:

let
  outputName = "TABLET";
  serviceName = "tablet-vnc.service";
  stateDirectory = "$HOME/.local/state/tablet-display";

  tabletDisplay = pkgs.writeShellApplication {
    name = "tablet-display";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
      gnugrep
      iproute2
      jq
      openssl
      systemd
    ];
    text = ''
      output_name=${outputName}
      service_name=${serviceName}
      state_directory=${stateDirectory}
      wayvnc_directory="$state_directory/wayvnc"
      password_file="$state_directory/password"
      config_file="$wayvnc_directory/config"

      usage() {
        echo "Usage: tablet-display {start|stop|restart|status|password|logs}"
      }

      lan_address() {
        ip -4 route get 1.1.1.1 2>/dev/null \
          | awk '{ for (i = 1; i <= NF; i++) if ($i == "src") { print $(i + 1); exit } }' \
          || true
      }

      output_exists() {
        hyprctl -j monitors all \
          | jq -e --arg output "$output_name" 'any(.[]; .name == $output)' >/dev/null
      }

      ensure_config() {
        mkdir -p "$wayvnc_directory"
        chmod 700 "$state_directory" "$wayvnc_directory"

        if [[ ! -s "$password_file" ]]; then
          openssl rand -base64 18 > "$password_file"
          chmod 600 "$password_file"
        fi

        if [[ ! -s "$wayvnc_directory/tls_key.pem" || ! -s "$wayvnc_directory/tls_cert.pem" ]]; then
          local address
          local subject_alt_name
          address="$(lan_address)"
          subject_alt_name="DNS:localhost,IP:127.0.0.1"
          if [[ -n "$address" ]]; then
            subject_alt_name="$subject_alt_name,IP:$address"
          fi

          openssl req -x509 -newkey ec \
            -pkeyopt ec_paramgen_curve:secp384r1 \
            -sha384 -days 3650 -nodes \
            -keyout "$wayvnc_directory/tls_key.pem" \
            -out "$wayvnc_directory/tls_cert.pem" \
            -subj "/CN=tablet-display" \
            -addext "subjectAltName=$subject_alt_name" >/dev/null 2>&1
          chmod 600 "$wayvnc_directory/tls_key.pem"
        fi

        local password
        password="$(tr -d '\n' < "$password_file")"
        {
          echo "use_relative_paths=true"
          echo "address=0.0.0.0"
          echo "port=5900"
          echo "enable_auth=true"
          echo "relax_encryption=true"
          echo "username=${config.home.username}"
          echo "password=$password"
          echo "private_key_file=tls_key.pem"
          echo "certificate_file=tls_cert.pem"
        } > "$config_file"
        chmod 600 "$config_file"
      }

      show_connection() {
        local address
        address="$(lan_address)"
        if [[ -z "$address" ]]; then
          address="<this-computer's-IP>"
        fi

        echo "Tablet display is available at $address:5900"
        echo "Username: ${config.home.username}"
        echo "Password: $(tr -d '\n' < "$password_file")"
      }

      start() {
        if systemctl --user is-active --quiet "$service_name"; then
          show_connection
          return
        fi

        if [[ -z "''${WAYLAND_DISPLAY:-}" || -z "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
          echo "tablet-display must be started from the active Hyprland session" >&2
          exit 1
        fi

        ensure_config
        systemctl --user import-environment WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE

        local created_output=false
        if ! output_exists; then
          hyprctl output create headless "$output_name"
          created_output=true
        fi

        if ! systemctl --user start "$service_name"; then
          if [[ "$created_output" == true ]]; then
            hyprctl output remove "$output_name" || true
          fi
          exit 1
        fi

        show_connection
      }

      stop() {
        systemctl --user stop "$service_name"
        if output_exists; then
          hyprctl output remove "$output_name"
        fi
      }

      case "''${1:-}" in
        start)
          start
          ;;
        stop)
          stop
          ;;
        restart)
          stop
          start
          ;;
        status)
          systemctl --user status "$service_name" --no-pager || true
          if output_exists; then
            echo "Hyprland output $output_name exists"
          else
            echo "Hyprland output $output_name is absent"
          fi
          ;;
        password)
          ensure_config
          tr -d '\n' < "$password_file"
          echo
          ;;
        logs)
          journalctl --user --unit "$service_name" --follow
          ;;
        *)
          usage >&2
          exit 2
          ;;
      esac
    '';
  };
in
{
  home.packages = [
    pkgs.wayvnc
    tabletDisplay
  ];

  wayland.windowManager.hyprland.settings.monitor = [
    {
      output = outputName;
      mode = "1920x1200@60";
      position = "1920x0";
      scale = 1;
    }
  ];

  systemd.user.services.tablet-vnc = {
    Unit = {
      Description = "WayVNC server for the tablet display";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.wayvnc}/bin/wayvnc --config=%h/.local/state/tablet-display/wayvnc/config --output=${outputName} --max-fps=30 --render-cursor --log-level=info";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
}
