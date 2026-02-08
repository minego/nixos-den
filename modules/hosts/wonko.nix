# wonko - Steam Deck

{ config, ... }: let
	name = "wonko";
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
			hardware_laptop
			hardware_cpu_amd
			hardware_gpu_amd
			hardware_network_NetworkManager
			hardware_network_tailscale_client

			# Software
			software
			software_dev
			software_desktop
			software_gaming_steamos

			# Users
			users_root
			users_m

			{
				# Filesystems
				fileSystems."/boot" = {
					device			= "/dev/disk/by-uuid/EB2D-3BFA";
					fsType			= "vfat";
					options			= [ "noatime" ];
				};

				fileSystems."/" = {
					device			= "/dev/disk/by-uuid/1bb334e6-3c14-46b3-9bae-d50053587d50";
					fsType			= "ext4";
				};

				boot.initrd.availableKernelModules	= [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" "sdhci_pci" ];
			}
		];
	};
}

