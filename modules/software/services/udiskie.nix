let
	module = { pkgs, lib, ... }: {
		# Start udiskie, for auto mounting removable media
		systemd.user.services.udiskie = {
			partOf				= [ "graphical-session.target" ];
			after				= [ "graphical-session.target" ];
			wantedBy			= [ "graphical-session.target" ];
			requisite			= [ "graphical-session.target" ];

			serviceConfig = {
				Type			= "simple";
				Restart			= "on-failure";
				ExecStart		= "${(lib.getExe' pkgs.udiskie "udiskie")} --tray";
			};
		};
	};
in {
	flake.modules.nixos.software_desktop	= module;
	flake.modules.nixos.software_udiskie	= module;
}

