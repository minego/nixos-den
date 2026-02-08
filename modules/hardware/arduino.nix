{
	flake.modules.nixos.hardware_arduino = { host, pkgs, ... }: {
		# Allow access to arduino devices
		services.udev.extraRules = ''
		   KERNEL=="ttyACM0", MODE:="666"
		   KERNEL=="ttyACM1", MODE:="666"
		   
		   SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="00??", GROUP="plugdev", MODE="0666"
		   SUBSYSTEMS=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="????", GROUP="plugdev", MODE="0666"
		   '';

		environment.systemPackages = with pkgs; [
			# adafruit-nrfutil
			tio
		];

		users.users.${host.primaryUser}.extraGroups	= [ "networkmanager" ];
	};
}
