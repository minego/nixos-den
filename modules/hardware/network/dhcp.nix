{
	flake.modules.nixos.hardware_network_dhcp = { lib, host, ... }: {
		networking.hostName = host.name;

		systemd.network = {
			enable					= true;
			networks."10-enp2s0" = {
				matchConfig.Name	= "enp2s0";
				networkConfig.DHCP	= "yes";
			};
		};
		networking.useDHCP			= lib.mkForce false;

		# This is required for VMs using just static DHCP, or DNS will not
		# function at all.
		system.nssDatabases.hosts	= (lib.mkOrder 301 [ "dns" ]);
	};
}
