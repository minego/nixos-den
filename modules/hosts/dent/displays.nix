{ config, ... }: {
	hostConfig.dent = {
		primaryDisplay = config.hostConfig.dent.displays.DP-3;

		displays = {
			DP-3 = {
				primary		= true;
				width		= 3840;
				height		= 2160;
				refresh		= 119.999;
				vrr			= true;
			};
		};
	};
}
