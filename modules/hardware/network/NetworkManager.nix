{
	flake.modules.nixos.hardware_network_NetworkManager = { lib, host, ... }: {
		networking.hostName = host.name;

		networking.networkmanager = {
			enable									= true;
			wifi.powersave							= true;
		};

		# Default to using DHCP, but using NM means the user can override
		# as they want, including connecting to wifi networks.
		networking.useDHCP							= lib.mkDefault true;

		# Disable the applet, because the DMS menu is nicer
		programs.nm-applet.enable					= lib.mkForce false;
		systemd.user.services.app-nm-applet.enable	= lib.mkForce false;
		systemd.user.services.nm-applet.enable		= lib.mkForce false;

		# Prevent failig to do a switch because networkmanager takes too long
		systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
	};
}
