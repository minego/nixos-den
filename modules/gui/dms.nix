{ inputs, ... }: {
	minego.gui._.dms = { ... }: {
		nixos = { pkgs, config, ... }: {
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
				script                          = "${(pkgs.writeShellScriptBin "dms-wrapped" ''
					rm -rf ~/.config/DankMaterialShell.bk							2>/dev/null
					mv ~/.config/DankMaterialShell ~/.config/DankMaterialShell.bk	2>/dev/null

					if [ -d ~/src/nix/nixos-den/modules/gui/dms ]; then
						ln -s ~/src/nix/nixos-den/modules/gui/dms ~/.config/DankMaterialShell
					else
						ln -s "${./DankMaterialShell}" ~/.config/DankMaterialShell
					fi

					${pkgs.bash}/bin/bash -c							\
						'source ${config.system.build.setEnvironment}	; \
						exec dms run --session'
					'')}/bin/dms-wrapped";

				# This conflicts with the DMS polkit agent
				systemd.user.services.niri-flake-polkit.enable = false;
			};
		};
	};
}
