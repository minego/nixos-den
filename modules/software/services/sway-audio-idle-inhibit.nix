let
	module = { pkgs, lib, ... }: {
		systemd.user.services.sway-audio-idle-inhibit = let
			inhibit				= lib.getExe' pkgs.sway-audio-idle-inhibit "sway-audio-idle-inhibit";
		in {
			partOf				= [ "graphical-session.target" ];
			after				= [ "graphical-session.target" ];
			wantedBy			= [ "graphical-session.target" ];
			requisite			= [ "graphical-session.target" ];

			serviceConfig = {
				Type			= "simple";
				Restart			= "on-failure";
				ExecStart		= "${inhibit}";
			};
		};
	};
in {
	flake.modules.nixos.software_desktop			= module;
	flake.modules.nixos.software_swayidleinhibit	= module;
}

