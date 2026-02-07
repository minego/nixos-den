# agrajag - MinisForums V3 Tablet PC

{ minego, config, inputs, ... }: {
	hostConfig.agrajag = {};

	den.aspects.agrajag = {
		includes = [
			minego.laptop

			minego.gaming._.max
			minego.hardware._.amdgpu
			minego.hardware._.fingerprint

			minego.secrets._.mosquitto

			minego.networking._.networkManager
			minego.networking._.tailscale._.client
		];

		nixos = { ... }: {
			networking.hostName					= "agrajag";

			imports = with inputs; [
				nixos-hardware.nixosModules.common-cpu-amd
				nixos-hardware.nixosModules.common-gpu-amd
				nixos-hardware.nixosModules.common-pc-ssd
				nixos-hardware.nixosModules.minisforum-v3
			];

			nixpkgs.config.rocmSupport			= true;
			services.fwupd.enable				= true;
			security.rtkit.enable				= true;

			hardware = {
				amdgpu.opencl.enable			= true;
				bluetooth.enable				= true;
				cpu.amd.updateMicrocode			= true; 
			};

			boot = {
				initrd.availableKernelModules	= [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" "cryptd" "aesni_intel" ];
				kernelModules					= [ "kvm-amd" ];

				binfmt = {
					emulatedSystems				= [ "aarch64-linux" ];
				    preferStaticEmulators		= true; # Make it work with Docker
				};
			};
		};
	};

	den.hosts.x86_64-linux.agrajag = {
		inherit (config.hostConfig.agrajag) displays primaryDisplay;

		users.m = {};
	};
}
