{ inputs, ... }: {
	minego.hardware._."amdgpu" = {
		nixos = { pkgs, ... }: {
			imports = [
				inputs.nixos-hardware.nixosModules.common-gpu-amd
			];

			boot = {
				initrd.kernelModules				= [ "amdgpu" ];
				kernelParams						= [ "amdgpu.dpm=1" ];


				binfmt = {
					emulatedSystems					= [ "aarch64-linux" ];
				    preferStaticEmulators			= true; # Make it work with Docker
				};
			};
			environment.variables.AMD_VULKAN_ICD	= "RADV";

			hardware = {
				amdgpu.opencl.enable				= true;

				graphics = {
					enable							= true;
					enable32Bit						= true;
				};
			};

			nixpkgs.config.rocmSupport				= true;

			environment.systemPackages = with pkgs; [
				clinfo
				vulkan-tools # For tools such as vulkaninfo
			];

			programs.corectrl.enable				= true;
		};
	};
}
