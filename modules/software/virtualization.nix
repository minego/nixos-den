{
	flake.modules.nixos.software_virtualization = { config, pkgs, host, ... }: {
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

		users.users.${host.primaryUser}.extraGroups	= [ "kvm" "libvirtd" ];
	};

	flake.modules.nixos.software_virtualization_docker = { host, ... }: {
		virtualisation = {
			containers.enable				= true;
			docker.enable					= true;
		};
		users.users.${host.primaryUser}.extraGroups	= [ "docker" ];
	};

	flake.modules.nixos.software_virtualization_waydroid = {
		virtualisation.waydroid.enable		= true;
	};

	flake.modules.nixos.hardware_vm = { pkgs, ... }: {
		services.qemuGuest.enable			= true;

		environment.systemPackages = with pkgs; [
			open-vm-tools
		];
	};
}
