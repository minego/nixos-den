{ ... }: {
	minego.hardware._."armcpu" = {
		nixos = { ... }: {
			boot = {
				binfmt = {
					emulatedSystems				= [ "x86_64-linux" ];
					preferStaticEmulators		= true; # Make it work with Docker
				};
			};
		};
	};
}
