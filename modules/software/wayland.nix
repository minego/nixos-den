let
	module = { inputs, pkgs, lib, ... }: {
		services.dbus.enable				= true;
		services.seatd.enable				= true;
		programs.light.enable				= true;

		# Stop auto-starting nm-applet!!!!
		xdg.autostart.enable				= lib.mkForce false;

		# This environment variable is used by many applications in
		# NixOS to tell it to run in Wayland instead of X.
		environment.variables.NIXOS_OZONE_WL= "1";

		# This is required to use the lldb-vscode DAP to debug on
		# Linux, and I tend to need to do that on any system that is a
		# "desktop" so that is why I put this here.
		boot.kernel.sysctl."kernel.yama.ptrace_scope" = lib.mkForce 0;

		# ydotool for the sake of an on screen keyboard with quickshell
		programs.ydotool = {
			enable                          = true;
			group                           = "wheel";
		};

		nixpkgs.overlays = [
			inputs.quickshell.overlays.default
			inputs.osk.overlays.default
		];

		xdg.portal = {
			enable							= true;
			xdgOpenUsePortal				= true;
			extraPortals = [
				pkgs.xdg-desktop-portal-gtk
				pkgs.xdg-desktop-portal-gnome
			];
		};

		environment.systemPackages = with pkgs; [
			xdg-utils
			wl-clipboard
			wayland-utils
			brightnessctl
			wlr-randr
			wdisplays
			cage
			nautilus

			freerdp
			tigervnc
			remmina
			mpv
			vlc
			sway-contrib.grimshot
			qalculate-gtk
			notify-client # ntfy.sh client
			mupdf

			bluez
			blueberry
			mesa-demos
			foot
			xterm

			hypridle
			udiskie
			rquickshare

			# signal-desktop
			orca-slicer

			qs-osk
			qs-osk-desktop

			(pkgs.makeDesktopItem {
				name		= "rotate";
				desktopName = "rotate";
				exec		= ./../../scripts/rotate;
				icon		= ./../../assets/rotate.png;
			})
		] ++ lib.optionals (stdenv.isLinux && stdenv.isx86_64) [
			# These aren't available on aarch64 linux
			slack
			deezer-enhanced
		];
	};
in {
	flake.modules.nixos.software_wayland	= module;
	flake.modules.nixos.software_desktop	= module;
}
