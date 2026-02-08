# dishoftheday - Development VM

{ minego, config, ... }: let
	hostname = "dishoftheday";
in {
	hostConfig."${hostname}" = {
		displays.DP-3 = {
			primary		= true;
			width		= 2560;
			height		= 1600;
			refresh		= 59.987;
			vrr			= true;
		};
		primaryDisplay = config.hostConfig.dent.displays.DP-3;
	};

	den.aspects."${hostname}" = {
		includes = [
			minego.laptop
			minego.hardware._.armcpu
			minego.networking._.networkManager
			minego.power-mgmt._.ignorePowerKey
		];

		nixos = { pkgs, ... }: {
			networking.hostName					= "${hostname}";

			boot = {
				initrd.availableKernelModules	= [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
			};

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

			environment.systemPackages = with pkgs; [
				open-vm-tools
			];

			virtualisation.vmware.guest.enable	= true;
			services.xserver.videoDrivers		= [ "vmware" ];
			environment.variables = {
				WLR_NO_HARDWARE_CURSORS			= "1";
			};
		};
	};

	den.hosts.aarch64-linux."${hostname}" = {
		inherit (config.hostConfig."${hostname}") displays primaryDisplay;

		users.m = {};
	};
}
