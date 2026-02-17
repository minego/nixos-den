# hotblack - Home server

{ config, ... }: let
	name = "hotblack";
in {
	nixosHosts.${name} = {
		inherit name;

		system				= "x86_64-linux";
		unstable			= true;

		ignorePowerButton	= false;

		modules = with config.flake.modules.nixos; [
			base

			# Hardware
			hardware_cpu_intel
			hardware_desktop
			hardware_network_tailscale_both

			# Software
			software
			software_dev
			software_virtualization
			software_virtualization_docker

			# minego.net services
			sites_minego_net

			# Users
			users_root
			users_m
			users_ha # Home Assistant

			{
				# Filesystems
				fileSystems."/boot" = {
					device			= "/dev/disk/by-uuid/FAE2-40E4";
					fsType			= "vfat";
					options			= [ "noatime" ];
				};

				fileSystems."/" = {
					device			= "/dev/disk/by-uuid/fb497512-8861-4c33-bb1d-00ba581bceca";
					fsType			= "ext4";
				};

				fileSystems."/data" = {
					device			= "media";
					fsType			= "zfs";

					depends			= [ "/" ];
					options			= [ "relatime" "nofail" ];
				};

				# Fast nvme SSD
				fileSystems."/mnt/data" = {
					device			= "/dev/disk/by-uuid/7c0c654c-ed5a-4ee8-afa7-60ba53934361";
					fsType			= "ext4";
					depends			= [ "/" ];
					options			= [ "relatime" ];
				};

				# A hostId is needed for zfs
				# A new unique ID can be generated with:
				#	`head -c4 /dev/urandom | od -A none -t x4`
				networking.hostId				= "9d5bbde4";

				boot.supportedFilesystems		= [ "zfs" ];
				boot.zfs.forceImportRoot		= false;
				services.zfs = {
					autoScrub.enable			= true;
					trim.enable					= true;
				};

				boot.initrd.availableKernelModules	= [ "ahci" "xhci_pci" "ata_generic" "ehci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" "rtsx_usb_sdmmc" ];
			}

			# Networking
			{
				# Enable networking, with DHCP and a bridge device
				networking.useDHCP						= false;

				# Setup a bridge to be used with libvirt
				networking.interfaces.eno1.useDHCP		= false;
				networking.interfaces.br0.useDHCP		= true;
				networking.bridges.br0.interfaces		= [ "eno1" ];

				networking.nat = {
					enable								= true;
					internalInterfaces					= ["ve-+"];
					externalInterface					= "br0";
				};

				# Disable TCPSegmentationOffload and GenericSegmentationOffload for
				# the e1000 network card.
				#
				# When those are on the card in this machine behaves badly, and
				# will randomly stop responding to network requests for a few
				# seconds at a time.
				systemd.services."fix-iface-eno1" = {
					wantedBy	= [ "multi-user.target"	];
					after		= [ "network.target"	];
					description	= "Set needed options for the eno1 interface";
					script		= "${pkgs.ethtool}/bin/ethtool -K eno1 tso off gso off";
				};

				# Set options recommended by tailscale
				systemd.services."fix-iface-br0" = {
					wantedBy	= [ "multi-user.target"	];
					after		= [ "network.target"	];
					description	= "Set needed options for the br0 interface";
					script		= "${pkgs.ethtool}/bin/ethtool -K br0 rx-udp-gro-forwarding on rx-gro-list off";
				};
			}
		];
	};
}

