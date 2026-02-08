{ minego, ... }: {
	minego.hardware._."printer"._ = {
		server = {
			nixos = { pkgs, ... }: {
				# Enable support for printing
				services.printing = {
					enable									= true;
					drivers									= [ pkgs.brlaser ];
				};

				hardware = {
					# Enable support for scanners
					sane = {
						enable								= true;
						# brscan5.enable						= true;
						# brscan4.enable						= true;
						extraBackends						= [ pkgs.sane-airscan ];
					};
				};
			};
		};

		# Enable parallel port printers
		#
		# Note: The `usblp` kernel module is blacklisted if CUPS is enabled, so
		# using both will prevent printing directly to the device, which is my
		# preferred approach.
		#
		# https://github.com/NixOS/nixpkgs/blob/b4346092ca78dff067983a5b285e1fdad8754d1a/nixos/modules/services/printing/cupsd.nix#L363
		dotmatrix = {
			nixos = { ... }: {
				includes = [ (minego.groups "lp") ];

				services.ipp-usb.enable						= true;
				services.udev.extraRules = ''
					SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7584", GROUP="lp", MODE="0666", SYMLINK+="usb/lp0"
				'';

				boot.kernelModules							= [ "lp" "usblp" ];
			};
		};
	};
}
