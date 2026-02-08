{ ... }: {
	minego.gaming.provides = {
		alvr = { ... }: {
			nixos = { ... }: {
				programs.alvr = {
					enable								= true;
					openFirewall						= true;
				};
			};
		};
	};
}

