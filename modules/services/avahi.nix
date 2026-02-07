{
	minego.avahi.provides = {
		server.nixos = {
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
	};
}
