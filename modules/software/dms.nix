let
	module = { inputs, pkgs, config, ... }: {
		imports = [
			inputs.dms.nixosModules.dank-material-shell
		];

		programs.dank-material-shell = {
			enable							= true;
			enableSystemMonitoring			= true;
			enableDynamicTheming			= true;

			# I have my own customized version below
			systemd.enable					= false;
		};

		systemd.user.services.dms = {
			description						= "DankMaterialShell";

			partOf                          = [ "graphical-session.target" ];
			after                           = [ "graphical-session.target" "niri.service" ];
			wantedBy                        = [ "graphical-session.target" "niri.service" ];
			requisite                       = [ "graphical-session.target" ];

			serviceConfig = {
				Type						= "simple";
				Restart						= "on-failure";
			};

			# The script below sources the system's build environment
			# to add things to the path. This is important, since dms
			# is being used as our launcher and needs access to all our
			# applications.
			#
			# This attempts to symlink the ./dms dir as the configuration
			# dir for DMS. If it can't, then it copies it.
			script                          = "${(pkgs.writeShellScriptBin "dms-wrapped" ''
				rm -rf ~/.config/DankMaterialShell.bk							2>/dev/null
				mv ~/.config/DankMaterialShell ~/.config/DankMaterialShell.bk	2>/dev/null

				if [ -d ~/src/nix/nixos-den/modules/gui/dms ]; then
					ln -s ~/src/nix/nixos-den/modules/gui/dms ~/.config/DankMaterialShell
				else
					ln -s "${./dms}" ~/.config/DankMaterialShell
				fi

				${pkgs.bash}/bin/bash -c							\
					'source ${config.system.build.setEnvironment}	; \
					exec dms run --session'
				'')}/bin/dms-wrapped";
		};

		# Restart DMS (if running) because if we don't then we can end up with
		# a different version in the path vs the one that is running and that
		# breaks the DMS ipc mechanism.
		system.userActivationScripts.restartDMS.text = ''
			if ${pkgs.systemd}/bin/systemctl --user status dms.service >/dev/null; then
				${pkgs.systemd}/bin/systemctl --user restart dms.service
			fi
			'';

		# This conflicts with the DMS polkit agent
		systemd.user.services.niri-flake-polkit.enable = false;
	};
in {
	# Dank Material Shell is included in the main desktop aspect
	flake.modules.nixos.software_dms		= module;
	flake.modules.nixos.software_desktop	= module;
}
