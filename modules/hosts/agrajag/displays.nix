{ config, ... }: {
	hostConfig.agrajag = {
		primaryDisplay = config.hostConfig.agrajag.displays.eDP-1;

		displays = {
			eDP-1 = {
				primary		= true;
				width		= 2500;
				height		= 1600;
				vrr			= true;
			};
		};
	};
}
