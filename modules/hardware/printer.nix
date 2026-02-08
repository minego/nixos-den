{
	flake.modules.nixos.hardware_printer = {
		services.ipp-usb.enable						= true;
		services.udev.extraRules = ''
			SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7584", GROUP="lp", MODE="0666", SYMLINK+="usb/lp0"
		'';

		boot.kernelModules							= [ "lp" "usblp" ];
	};
}
	
