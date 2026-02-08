let
	module = {
		programs.alvr = {
			enable								= true;
			openFirewall						= true;
		};
	};
in {
	flake.modules.nixos.software_alvr	= module;
}

