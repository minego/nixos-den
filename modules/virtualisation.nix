{ den, minego, ... }: {
	minego.virt.provides = {
		qemu = den.lib.parametric {
			includes = [ (minego.groups "kvm") ];

			nixos = { pkgs, config, ... }: {
				# NOTE: Run `virt-host-validate` to verify the system is setup properly
				programs.virt-manager.enable		= true;

				environment.systemPackages = with pkgs; [
					virt-manager
					virt-viewer
					spice
					spice-gtk
					spice-protocol
					virtio-win
					win-spice
					virtiofsd
					virglrenderer
				];

				services.qemuGuest.enable			= true;
				virtualisation = {
					libvirtd = {
						enable						= true;
						onShutdown					= "suspend";
						onBoot						= "ignore";

						qemu.swtpm.enable			= true;
					};

					spiceUSBRedirection.enable		= true;
				};

				services.spice-vdagentd.enable		= true;
				boot.extraModprobeConfig			= "options kvm_intel nested=1";

				environment.etc = {
					"ovmf/edk2-x86_64-secure-code.fd" = {
						source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
					};

					"ovmf/edk2-i386-vars.fd" = {
						source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
					};
				};
			};
		};

		docker = {
			nixos = {
				virtualisation = {
					containers.enable				= true;
					docker.enable					= true;
				};
			};
		};

		waydroid = {
			nixos = {
				virtualisation.waydroid.enable		= true;
			};
		};
	};
}
