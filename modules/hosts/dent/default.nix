# dent - Desktop PC

{ minego, config, inputs, ... }: let
	hostname = "dent";
in {
	hostConfig."${hostname}" = {};

	den.aspects."${hostname}" = {
		includes = [
			minego.desktop

			minego.gaming._.max
			minego.hardware._.amdgpu

			minego.secrets._.mosquitto

			minego.networking._.networkManager
			minego.networking._.tailscale._.client
		];

		nixos = { ... }: {
			networking.hostName					= "${hostname}";

			imports = with inputs; [
				nixos-hardware.nixosModules.common-cpu-amd
				nixos-hardware.nixosModules.common-gpu-amd
				nixos-hardware.nixosModules.common-pc-ssd
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
				initrd.availableKernelModules	= [
					"nvme"
					"xhci_pci"
					"thunderbolt"
					"ahci"
					"usb_storage"
					"usbhid"
					"sd_mod"
					"rtsx_pci_sdmmc"
					"cryptd"
					"aesni_intel"
				];
				kernelModules					= [ "kvm-amd" ];

				binfmt = {
					emulatedSystems				= [ "aarch64-linux" ];
				    preferStaticEmulators		= true; # Make it work with Docker
				};
			};
		};
	};

	den.hosts.x86_64-linux."${hostname}" = {
		inherit (config.hostConfig."${hostname}") displays primaryDisplay;

		users.m = {};
	};
}
