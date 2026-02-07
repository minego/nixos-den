{ minego, ... }: {
	minego.networking = {
		nixos = {
		};

		provides.dhcp = {
			includes = [ minego.networking ];

			nixos = {
				networking.useDHCP			= true;
			};
		};
	};
}
