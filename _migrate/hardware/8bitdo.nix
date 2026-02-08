{
	minego.hardware._."8bitdo" = {
		nixos = { pkgs, ... }: {
			# Udev rules to start or stop systemd service when controller is connected or disconnected
			services.udev.extraRules = ''
				# May vary depending on your controller model, find product id using 'lsusb'
				SUBSYSTEM=="usb", ATTR{idVendor}=="2dc8", ATTR{idProduct}=="3106", ATTR{manufacturer}=="8BitDo", RUN+="${pkgs.systemd}/bin/systemctl start 8bitdo-ultimate-xinput@2dc8:3106"

				# This device (2dc8:3016) is "connected" when the above device disconnects
				SUBSYSTEM=="usb", ATTR{idVendor}=="2dc8", ATTR{idProduct}=="3016", ATTR{manufacturer}=="8BitDo", RUN+="${pkgs.systemd}/bin/systemctl stop 8bitdo-ultimate-xinput@2dc8:3106"
			'';
		};
	};
}
