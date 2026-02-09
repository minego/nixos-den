{
	flake.modules.nixos.hardware_cpu_intel = { inputs, ... }: {
		imports = [
			inputs.nixos-hardware.nixosModules.common-cpu-intel
			inputs.nixos-hardware.nixosModules.common-pc-ssd
		];

		hardware = {
			cpu.intel.updateMicrocode		= true; 
		};

		boot = {
			kernelModules					= [ "kvm-intel" ];

			binfmt = {
				emulatedSystems				= [ "aarch64-linux" ];
				preferStaticEmulators		= true; # Make it work with Docker
			};
		};
	};
}
