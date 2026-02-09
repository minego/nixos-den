# agrajag - MinisForums V3 Tablet PC

{ inputs, config, ... }: let
	name = "agrajag";
in {
	nixosHosts.${name} = rec {
		inherit name;

		system				= "x86_64-linux";
		unstable			= true;

		displays.eDP-1 = {
			primary			= true;
			width			= 2500;
			height			= 1600;
			vrr				= true;
			refresh			= 60.0;
		};

		primaryDisplay		= displays.eDP-1;

		ignorePowerButton	= false;

		modules = with config.flake.modules.nixos; [
			base

			# Hardware
			hardware_laptop
			hardware_cpu_amd
			hardware_gpu_amd
			hardware_fingerprint
			hardware_network_NetworkManager
			hardware_network_tailscale_client
			inputs.nixos-hardware.nixosModules.minisforum-v3

			# Software
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

