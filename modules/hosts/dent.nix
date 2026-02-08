# dent - Desktop PC

{ config, ... }: let
	name = "dent";
in {
	nixosHosts.${name} = rec {
		inherit name;

		system				= "x86_64-linux";
		unstable			= true;

		displays.DP-3 = {
			primary		= true;
			width		= 3840;
			height		= 2160;
			refresh		= 119.999;
			vrr			= true;
		};

		primaryDisplay		= displays.DP-3;

		ignorePowerButton	= false;

		modules = with config.flake.modules.nixos; [
			base

			# Hardware
			hardware_desktop
			hardware_cpu_amd
			hardware_gpu_amd
			hardware_network_NetworkManager
			hardware_network_tailscale_client

			# Software
			software
			software_dev
			software_desktop
			software_gaming
			software_virtualization
			software_virtualization_waydroid
			software_virtualization_docker

			# Users
			users_root
			users_m

			{
				# Filesystems
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

				boot.initrd.availableKernelModules	= [
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
			}
		];
	};
}

