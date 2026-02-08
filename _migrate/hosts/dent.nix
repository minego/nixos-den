# dent - Desktop PC

{ minego, config, ... }: let
	hostname = "dent";
in {
	hostConfig."${hostname}" = {
		displays.DP-3 = {
			primary		= true;
			width		= 3840;
			height		= 2160;
			refresh		= 119.999;
			vrr			= true;
		};
		primaryDisplay = config.hostConfig.dent.displays.DP-3;
	};

	den.aspects."${hostname}" = {
		includes = [
			minego.desktop

			minego.gaming._.max
			minego.hardware._.amdgpu
			minego.hardware._.amdcpu

			minego.secrets._.mosquitto

			minego.networking._.networkManager
			minego.networking._.tailscale._.client
		];

		nixos = { ... }: {
			networking.hostName					= "${hostname}";

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
			};

			fileSystems."/boot" = {
				device			= "/dev/disk/by-uuid/8CC6-BDDD";
				fsType			= "vfat";
				options			= [ "noatime" ];
			};

			fileSystems."/" = {
				device			= "/dev/disk/by-uuid/51345dbe-c749-4043-b347-4231ab92c799";
				fsType			= "ext4";
			};

			boot.initrd.luks.devices = {
				"luks-3d83c353-b63b-413c-8f84-6a84ace5569a" = {
					device			= "/dev/disk/by-uuid/3d83c353-b63b-413c-8f84-6a84ace5569a";
					allowDiscards	= true;
				};

				"luks-d81962c8-e3d0-422b-8ff1-918452b9857f" = {
					device			= "/dev/disk/by-uuid/d81962c8-e3d0-422b-8ff1-918452b9857f";
					allowDiscards	= true;
				};
			};
		};
	};

	den.hosts.x86_64-linux."${hostname}" = {
		inherit (config.hostConfig."${hostname}") displays primaryDisplay;

		users.m = {};
	};
}
