{
	flake.modules.nixos.hardware_cpu_amd = { inputs, ... }: {
		imports = [
			inputs.nixos-hardware.nixosModules.common-cpu-amd
			inputs.nixos-hardware.nixosModules.common-pc-ssd
		];

		hardware = {
			cpu.amd.updateMicrocode			= true; 
		};

		boot = {
			kernelModules					= [ "kvm-amd" ];

			binfmt = {
				emulatedSystems				= [ "aarch64-linux" ];
				preferStaticEmulators		= true; # Make it work with Docker
			};
		};
	};
}
