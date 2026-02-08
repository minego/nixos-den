{
	flake.modules.nixos.hardware_keyboard = { inputs, pkgs, ... }: let
		plugins = {
			caps2esc	= pkgs.interception-tools-plugins.caps2esc;
			swapmods	= pkgs.minego.swapmods;
			mackeys		= pkgs.minego.mackeys;
			chrkbd		= pkgs.minego.chrkbd;
		};
	in
	{
		nixpkgs.overlays = [
			inputs.swapmods.overlay
			inputs.mackeys.overlay
			inputs.chrkbd.overlay
		];

		# Interception-Tools
		services.interception-tools = let
			intercept	= "${pkgs.interception-tools}/bin/intercept";
			uinput		= "${pkgs.interception-tools}/bin/uinput";
			chrkbd		= "${plugins.chrkbd}/bin/chrkbd";
			mackeys		= "${plugins.mackeys}/bin/mackeys";
			caps2esc	= "${plugins.caps2esc}/bin/caps2esc";
			swapmods	= "${plugins.swapmods}/bin/swapmods";
		in {
			enable		= true;
			plugins		= [
				plugins.caps2esc
				plugins.mackeys
				plugins.swapmods
				plugins.chrkbd
			];

			# NOTE: This will fail if you leave any leading tabs here
			udevmonConfig = ''
				- JOB: "${intercept} -g $DEVNODE              | ${mackeys} -a | ${swapmods} | ${caps2esc} -m 1 | ${uinput} -d $DEVNODE"
				  DEVICE:
					NAME: USB Keyboard
					PRODUCT: 12906
					VENDOR: 1455
				- JOB: "${intercept} -g $DEVNODE | ${chrkbd}                | ${mackeys} | ${caps2esc} -m 1 | ${uinput} -d $DEVNODE"
				  DEVICE:
					NAME: Google Inc. Hammer
				- JOB: "${intercept} -g $DEVNODE              | ${mackeys} -a | ${swapmods} | ${caps2esc} -m 1 | ${uinput} -d $DEVNODE"
				  DEVICE:
					NAME: AT Translated Set 2 keyboard
				- JOB: "${intercept} -g $DEVNODE                            | ${mackeys} | ${caps2esc} -m 1 | ${uinput} -d $DEVNODE"
				  DEVICE:
					NAME: Apple MTP keyboard
				- JOB: "${intercept} -g $DEVNODE                            | ${mackeys} | ${caps2esc} -m 1 | ${uinput} -d $DEVNODE"
				  DEVICE:
					NAME: VMware VMware Virtual USB Keyboard
				- JOB: "${intercept} -g $DEVNODE                            | ${mackeys} | ${caps2esc} -m 1 | ${uinput} -d $DEVNODE"
				  DEVICE:
					NAME: ".*((k|K)(eyboard|EYBOARD)).*"
				'';
		};

		environment.systemPackages = with pkgs; [

		] ++ lib.optionals (stdenv.isLinux && stdenv.isx86_64) [
			# These aren't available on aarch64 linux
			via
			vial
		];

		services.udev.packages = with pkgs; [
			qmk
			qmk-udev-rules
			qmk_hid
		] ++ lib.optionals (stdenv.isLinux && stdenv.isx86_64) [
			# These aren't available on aarch64 linux
			via
			vial
		];

		hardware.keyboard = {
			qmk.enable						= true;
		};

		hardware.bluetooth.input.General = {
			# Set the idle timeout to 0 to disable it. Without this my
			# Quefrency keyboard constantly connects and disconnects...
			IdleTimeout						= 0;
		};
	};
}
