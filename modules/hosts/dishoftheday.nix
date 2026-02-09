# dishoftheday - Development VM

{ config, ... }: let
	name = "dishoftheday";
in {
	nixosHosts.${name} = rec {
		inherit name;

		system				= "aarch64-linux";
		unstable			= true;

		displays."Unknown - Unknown - Virtual-1" = {
			primary		= true;
			width		= 2560;
			height		= 1600;
			refresh		= 59.987;
			vrr			= true;
		};

		primaryDisplay		= displays."Unknown - Unknown - Virtual-1";

		ignorePowerButton	= false;

		modules = with config.flake.modules.nixos; [
			base

			# Hardware
			hardware_desktop
			hardware_network_dhcp
			hardware_vm

			# Software
			software
			software_dev
			software_desktop
			software_virtualization_docker

			# Users
			users_root
			users_m

			{
				# Filesystems
				fileSystems."/boot" = {
					device			= "/dev/disk/by-uuid/9406-FFEE";
					fsType			= "vfat";
					options			= [ "noatime" ];
				};

				fileSystems."/" = {
					device			= "/dev/disk/by-uuid/f37431a2-7c99-44c5-8995-f38ce1283f18";
					fsType			= "ext4";
				};

				boot.initrd.luks.devices = {
					"luks-027f7951-e8a1-4a6a-b28e-547bed49f2bc" = {
						device			= "/dev/disk/by-uuid/027f7951-e8a1-4a6a-b28e-547bed49f2bc";
						allowDiscards	= true;
					};
				};

				boot.initrd.availableKernelModules	= [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
			}
		];
	};
}

