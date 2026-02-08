let
	module = {
		services.avahi = {
			enable				= true;
			openFirewall		= true;
			publish = {
				enable			= true;
				userServices	= true;
			};

			nssmdns4			= true;
		};
	};
in {
	flake.modules.nixos.software				= module;
	flake.modules.nixos.software_services_avahi	= module;
}
