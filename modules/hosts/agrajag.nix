# agrajag - MinisForums V3 Tablet PC

{ minego, config, inputs, ... }: let
	hostname = "agrajag";
in {
	hostConfig.${hostname} = {
		displays.eDP-1 = {
			primary		= true;
			width		= 2500;
			height		= 1600;
			vrr			= true;
			refresh		= 60.0;
		};
		primaryDisplay = config.hostConfig.${hostname}.displays.eDP-1;
	};

	den.aspects.${hostname} = {
		includes = [
			minego.laptop

			minego.gaming._.max
			minego.hardware._.amdgpu
			minego.hardware._.amdcpu
			minego.hardware._.fingerprint

			minego.secrets._.mosquitto

			minego.networking._.networkManager
			minego.networking._.tailscale._.client
		];

		nixos = { ... }: {
			networking.hostName					= "${hostname}";

			imports = with inputs; [
				nixos-hardware.nixosModules.minisforum-v3
			];

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

			# Filesystems
			fileSystems."/boot" = {
				device			= "/dev/disk/by-uuid/10EB-18AC";
				fsType			= "vfat";
				options			= [ "noatime" ];
			};

			fileSystems."/" = {
				device			= "/dev/disk/by-uuid/6ef2b006-2215-4291-a446-90b3bf9aaabc";
				fsType			= "ext4";
			};

			boot.initrd.luks.devices."luks-cdb4caa5-84d0-4273-a1ce-d077376cfc46" = {
				device			= "/dev/disk/by-uuid/cdb4caa5-84d0-4273-a1ce-d077376cfc46";
				allowDiscards	= true;
			};
		};
	};

	den.hosts.x86_64-linux.${hostname} = {
		inherit (config.hostConfig.${hostname}) displays primaryDisplay;

		users.m = {};
	};
}

