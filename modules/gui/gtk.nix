{
	minego.gui = {
		nixos = { pkgs, lib, ... }: {
			nixpkgs.overlays = [
				(_: super: {
					catppuccin-gtk = super.catppuccin-gtk.override {
						accents			= [ "pink" ];
						size			= "compact";
						tweaks			= [ "rimless" "black" ];
						variant			= "macchiato";
					};

					rquickshare = super.symlinkJoin {
						name			= "rquickshare";
						paths = [
							(pkgs.writeShellScriptBin "rquickshare"
							''
								mkdir -p ~/.local/share/dev.mandre.rquickshare/

								echo -en '{"startminimized": true, "port": 12345 }' > ~/.local/share/dev.mandre.rquickshare/.settings.json
								exec ${super.rquickshare}/bin/rquickshare
							'')
							super.rquickshare
						];
					};
				})
			];

			environment.systemPackages = with pkgs; [
				gtk3
				glib
				gsettings-desktop-schemas
				catppuccin-gtk
				papirus-icon-theme
				vimix-cursors
			];

			programs.dconf.enable			= true;

			# My default dconf settings
			#
			# These get loaded by the user systemd unit when logging in.
			#
			# Run `dconf dump /` to get the current settings, and then
			# pick and chose bits to set here if wanted.
			environment.etc."dconf.defaults" = {
				mode = "444";
				text = ''
					[org/gnome/desktop/interface]
					color-scheme='prefer-dark'
					cursor-size=24
					cursor-theme='Vimix-Cursor'
					gtk-theme='catppuccin-macchiato-pink-compact+rimless,black'
					icon-theme='Papirus-Dark'
					scaling-factor=uint32 1
					text-scaling-factor=1.0
					toolbar-style='text'
					
					[org/virt-manager/virt-manager]
					xmleditor-enabled=true
					
					[org/virt-manager/virt-manager/confirm]
					delete-storage=true
					forcepoweroff=true
					removedev=true
					unapplied-dev=true
					
					[org/virt-manager/virt-manager/connections]
					autoconnect=['qemu:///system', 'qemu+ssh://m@hotblack/system', 'qemu+ssh://m@dent/system']
					uris=['qemu+ssh://m@dent/system', 'qemu+ssh://m@hotblack/system', 'qemu+ssh://m@zaphod2/system', 'qemu+ssh://m@agrajag/system', 'qemu:///system']
					
					[org/virt-manager/virt-manager/details]
					show-toolbar=true
					
					[org/virt-manager/virt-manager/paths]
					image-default='/home/m'
					media-default='/home/m/Downloads'

					[org/blueman/general]
					plugin-list=['!StatusNotifierItem', '!ShowConnected', '!StatusIcon']
					'';
			};

			# Global GTK3 config for things this that ignore dconf
			environment.etc."xdg/gtk-3.0/settings.ini" = {
				mode = "444";
				text = ''
					   [Settings]
					   gtk-icon-theme-name=Papirus-Dark
					   gtk-cursor-theme-name=Vimix-Cursor
					   gtk-theme-name=catppuccin-macchiato-pink-compact+rimless,black
					   gtk-application-prefer-dark-theme=1
					   '';
			};

			environment.variables = {
				# Set the theme with an environment variable as well, just to be sure
				GTK_THEME			= "catppuccin-macchiato-pink-compact+rimless,black";

				GSETTINGS_SCHEMA_DIR= "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
			}; 

			environment.extraInit = ''
				${(lib.getExe pkgs.dconf)} load -f / < /etc/dconf.defaults
				rm -f ~/.config/gtk-3.0/settings.ini
				
				export XDG_DATA_DIRS="${pkgs.catppuccin-gtk}/share:$XDG_DATA_DIRS"
				export XDG_CONFIG_DIRS="/etc/xdg:$XDG_CONFIG_DIRS"
				'';


		};
	};
}
