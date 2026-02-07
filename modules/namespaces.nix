{ den, __findFile, ... }:
{
	minego = {
		workstation = den.lib.parametric.atLeast {
			includes = [
				<minego/boot/graphical>
				<minego/lix>

				<minego/ssh/server>
				<minego/ssh/client>

				<minego/virt/qemu>
				<minego/virt/docker>
				<minego/virt/waydroid>

				<minego/hardware/keyboard>
				<minego/hardware/audio>
				<minego/hardware/8bitdo>
				<minego/hardware/arduino>

				<minego/gui/greeter>
				<minego/gui/niri>

				# <minego/secrets>
				# <minego/printing>
				# <minego/syncthing/client>
				# <minego/wayland/niri>
				# <minego/tailscale>
				# <minego/xdg>

				# <minego/networking>
			];
		};
		laptop = den.lib.parametric.atLeast {
			includes = [
				<minego/performance/responsive>
				<minego/power-mgmt>
				<minego/workstation>
			];
		};
		desktop = den.lib.parametric.atLeast {
			includes = [
				<minego/performance/max>
				<minego/power-mgmt>
				<minego/workstation>
				# <minego/networking/wol>
			];
		};
	};
}
