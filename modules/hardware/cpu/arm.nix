{
	flake.modules.nixos.hardware_cpu_arm = {
		boot = {
			binfmt = {
				emulatedSystems				= [ "x86_64-linux" ];
				preferStaticEmulators		= true; # Make it work with Docker
			};
		};
	};
}
