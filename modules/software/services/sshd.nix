let
	module = {
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
in {
	flake.modules.nixos.software				= module;
	flake.modules.nixos.software_services_sshd	= module;
}
