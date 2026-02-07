{
	minego.ssh.provides = {
		server.nixos = {
			services.openssh = {
				enable								= true;
				openFirewall						= true;
				allowSFTP							= true;
				settings = {
					PasswordAuthentication			= false;
					KbdInteractiveAuthentication	= false;
				};
			};
		};
	};
}
