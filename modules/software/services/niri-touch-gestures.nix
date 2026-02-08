let
	module = { pkgs, ... }: {
		# Handle screen edge gestures
		systemd.user.services.niri-touch-gestures = {
			partOf				= [ "graphical-session.target" ];
			after				= [ "graphical-session.target" ];
			wantedBy			= [ "graphical-session.target" ];
			requisite			= [ "graphical-session.target" ];

			serviceConfig = {
				Type			= "simple";
				Restart			= "on-failure";
				ExecStart		= "${(pkgs.writeShellScriptBin "touch-gestures" ''
								  #!/usr/bin/env bash
								  
								  LAST_DEV=""
								  ${pkgs.libinput}/bin/libinput list-devices | while IFS= read -r line; do
									set -f; IFS=':'
									set -- $line
								  
									name="$1"; shift
									value="$1"; shift
								  
									set +f; unset IFS
								  
									# remove leading whitespace characters
									value="''${value#"''${value%%[![:space:]]*}"}"
									# remove trailing whitespace characters
									value="''${value%"''${value##*[![:space:]]}"}"   
								  
									case "$name" in
										"Kernel")
											LAST_DEV="$value"
											;;
								  
										"Capabilities")
											if [ "$value" == "touch" ]; then
												${pkgs.lisgd}/bin/lisgd -v -d "$LAST_DEV"													\
													-g "1,RL,R,*,R,${pkgs.niri}/bin/niri msg action focus-column-right"						\
													-g "1,LR,L,*,R,${pkgs.niri}/bin/niri msg action focus-column-left"						\
													-g "1,UD,T,*,R,${pkgs.niri}/bin/niri msg action open-overview"							\
													-g "1,DU,B,*,R,${pkgs.niri}/bin/niri msg action spawn -- ${pkgs.qs-osk}/bin/osk"		\
													-g "1,UD,B,*,R,${pkgs.niri}/bin/niri msg action spawn -- ${pkgs.qs-osk}/bin/killosk"
											fi
											;;
								  
										*)
											;;
									esac
								  done
								  
								  wait
								  '')}/bin/touch-gestures";
			};
		};
	};
in {
	flake.modules.nixos.software_desktop			= module;
	flake.modules.nixos.software_niritouchgestures	= module;
}

