{
	minego.hardware._."amdgpu" = {
		nixos = { pkgs, ... }: {
			boot = {
				initrd.kernelModules				= [ "amdgpu" ];
				kernelParams						= [ "amdgpu.dpm=1" ];
			};
			environment.variables.AMD_VULKAN_ICD	= "RADV";

			hardware.graphics = {
				enable								= true;
				enable32Bit							= true;
			};

			environment.systemPackages = with pkgs; [
				clinfo
				vulkan-tools # For tools such as vulkaninfo
			];

			programs.corectrl.enable				= true;
		};
	};
}
