let
	module = { lib, pkgs, ... }: {
		# Start mpvpaper to show an animated wallpaper
		systemd.user.services.mpvpaper = {
			partOf				= [ "graphical-session.target" ];
			after				= [ "graphical-session.target" ];
			wantedBy			= [ "graphical-session.target" ];
			requisite			= [ "graphical-session.target" ];

			serviceConfig = {
				Type			= "simple";
				Restart			= "on-failure";
				ExecStart		= "${(lib.getExe pkgs.mpvpaper)} -n 100 '*' ${./../../../assets/wallpaper.mp4} -o \"--no-keepaspect --really-quiet --hwdec=auto\"";
			};
		};
	};
in {
	flake.modules.nixos.software_desktop	= module;
	flake.modules.nixos.software_mpvpaper	= module;
}

