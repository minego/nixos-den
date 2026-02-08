{
	minego.gui._.niri-auto-rotate = {
		nixos = { lib, pkgs, ... }: {
			# Automatically rotate the screen based on the accelerometer
			systemd.user.services.niri-auto-rotate = {
				partOf				= [ "graphical-session.target" ];
				after				= [ "graphical-session.target" ];
				wantedBy			= [ "graphical-session.target" ];
				requisite			= [ "graphical-session.target" ];

				serviceConfig = {
					Type			= "simple";
					Restart			= "on-failure";
					ExecStart		= "${(pkgs.writeShellScriptBin "auto-rotate-niri" ''
					  #!/usr/bin/env bash
					  
					  OUTPUT=$(${pkgs.niri}/bin/niri msg -j focused-output | ${pkgs.jq}/bin/jq -r '.name')
					  echo "Using output: $OUTPUT"
					  
					  function rotate {
						case $1 in
							"normal")
								${pkgs.niri}/bin/niri msg output $OUTPUT transform normal
							;;
							"right-up")
								${pkgs.niri}/bin/niri msg output $OUTPUT transform 270
							;;
							"bottom-up")
								${pkgs.niri}/bin/niri msg output $OUTPUT transform 180
							;;
							"left-up")
								${pkgs.niri}/bin/niri msg output $OUTPUT transform 90
							;;
						esac
					  
						sleep 1
						# Restart the gesture service, so it handles the right edges
						${(lib.getExe' pkgs.systemd "systemctl")} --user restart niri-touch-gestures
					  }
					  
					  while IFS='$\n' read -r line; do
						rotation="$(echo $line | sed -En "s/^.*orientation changed: (.*)/\1/p")"
						[[ !  -z  $rotation  ]] && rotate $rotation
					  done < <(stdbuf -oL ${pkgs.iio-sensor-proxy}/bin/monitor-sensor)
					  '')}/bin/auto-rotate-niri";
				};
			};
		};
	};
}

