let
	module = { inputs, host, lib, pkgs, ... }: let
		nirimodule = {
			programs.niri.settings = {
				hotkey-overlay.skip-at-startup		= true;
				prefer-no-csd						= true;

				xwayland-satellite.path				= "${(lib.getExe pkgs.xwayland-satellite)}";

				input = {
					warp-mouse-to-focus.enable		= true;
					focus-follows-mouse.enable		= true;
					workspace-auto-back-and-forth	= true;

					touchpad = {
						click-method				= "clickfinger";
						dwt							= true;
						dwtp						= true;

						natural-scroll				= false;
						tap							= false;
					};
				};

				switch-events = {
					# lid-open.spawn					= [];
					# lid-close.spawn					= [];
					tablet-mode-on.action.spawn			= [ "${pkgs.qs-osk}/bin/osk" ];
					tablet-mode-off.action.spawn		= [ "${pkgs.qs-osk}/bin/killosk" ];
				};

				cursor = {
					size							= 24;
					theme							= "Vimix-Cursors";
				};

				layout = {
					gaps							= 10;

					# Negative struts to offset the gaps at
					# screen edges
					struts = {
						top							= -10;
						right						= -10;
						bottom						= -10;
						left						= -10;
					};


					center-focused-column			= "never";
					default-column-width			= { proportion = 1.0 / 3.0; };

					preset-column-widths = [
						{ proportion = 1.0 / 3.0; }
						{ proportion = 1.0 / 2.0; }
						{ proportion = 2.0 / 3.0; }
						{ proportion = 1.0; }
					];

					focus-ring = {
						width						= 1;
						active.color				= host.colors.light.yellow;
						inactive.color				= host.colors.light.grey;
					};

					border = {
						width						= 1;
						active.color				= host.colors.light.grey;
						inactive.color				= host.colors.light.grey;
					};
				};

				workspaces = {
					"1".name						= "home";
					"2".name						= "work";
					"3".name						= "scratch 1";
					"4".name						= "scratch 2";
					"5".name						= "scratch 3";
					"6".name						= "scratch 4";
					"7".name						= "scratch 5";
					"8".name						= "music";
					"9".name						= "steam";
				};

				spawn-at-startup = [
					{ command = [(lib.getExe pkgs.kitty) ];}
					{ command = [
						"${(pkgs.writeShellScriptBin "start-graphical-session" ''
							cmd="${(lib.getExe' pkgs.systemd "systemctl")} --user"	
							''${cmd?} reset-failed
							
							''${cmd?} --no-legend --full --plain --state=inactive --no-pager list-units | cut -f1 -d' ' | while read -r unit; do
								''${cmd?} show ''${unit?} -p WantedBy | while read -r wantedby; do
									case "''${wantedby?}" in
										WantedBy=xdg-desktop-autostart.target)
											''${cmd?} --no-pager start ''${unit?}
											''${cmd?} --no-pager status ''${unit?}
											;;
							
										WantedBy=graphical-session.target)
											''${cmd?} --no-pager start ''${unit?}
											''${cmd?} --no-pager status ''${unit?}
											;;
									esac
								done
								echo
							done
							
							'')}/bin/start-graphical-session"
					]; }

					{ command = [ "${pkgs.rquickshare}/bin/rquickshare" ]; }
				];

				outputs = lib.mapAttrs (
					 _: v: with v; {
						mode					= { inherit width height refresh; };
						scale					= scaling;
						position				= { inherit x y; };
						variable-refresh-rate	= vrr;
						focus-at-startup		= lib.mkIf primary true;
					}
				) host.displays;

				binds = let
					dms								= "dms";
					kitty							= lib.getExe pkgs.kitty;
				in rec {
					"Alt+Shift+Slash".action.show-hotkey-overlay				= [];
					"Alt+Shift+Return".action.spawn								= "${kitty}";

					"Alt+Space" = {
						action.spawn											= [ "${dms}" "ipc" "spotlight" "toggle" ];
						hotkey-overlay.title									= "Toggle Application Launcher";
					};
					"Alt+Slash" = {
						action.spawn											= [ "${dms}" "ipc" "spotlight" "toggle" ];
						hotkey-overlay.title									= "Toggle Application Launcher";
					};
					"Alt+N" = {
						action.spawn											= [ "${dms}" "ipc" "notifications" "toggle" ];
						hotkey-overlay.title									= "Toggle Notification Center";
					};
					"Ctrl+Alt+Escape" = {
						action.spawn											= [ "${dms}" "ipc" "lock" "lock" ];
						hotkey-overlay.title									= "Toggle Lock Screen";
					};
					"Alt+X" = {
						action.spawn											= [ "${dms}" "ipc" "powermenu" "toggle" ];
						hotkey-overlay.title									= "Toggle Power Menu";
					};
					"XF86AudioRaiseVolume" = {
						allow-when-locked										= true;
						action.spawn											= [ "${dms}" "ipc" "audio" "increment" "5" ];
					};
					"Ctrl+Alt+K"												= XF86AudioRaiseVolume;
					"Ctrl+Super+K"												= XF86AudioRaiseVolume;
					"XF86AudioLowerVolume" = {
						allow-when-locked										= true;
						action.spawn											= [ "${dms}" "ipc" "audio" "decrement" "5" ];
					};
					"Ctrl+Alt+J"												= XF86AudioLowerVolume;
					"Ctrl+Super+J"												= XF86AudioLowerVolume;
					"XF86MonBrightnessUp" = {
						allow-when-locked										= true;
						action.spawn											= [ "${dms}" "ipc" "brightness" "increment" "5" "" ];
					};
					"Ctrl+Shift+K"												= XF86MonBrightnessUp;
					"XF86MonBrightnessDown" = {
						allow-when-locked										= true;
						action.spawn											= [ "${dms}" "ipc" "brightness" "decrement" "5" "" ];
					};
					"Ctrl+Shift+J"												= XF86MonBrightnessDown;
					"XF86AudioMute" = {
						allow-when-locked										= true;
						action.spawn											= [ "${dms}" "ipc" "audio" "mute" ];
					};
					"XF86AudioMicMute" = {
						allow-when-locked										= true;
						action.spawn											= [ "${dms}" "ipc" "audio" "micmute" ];
					};

					"Alt+W".action.close-window									= [];

					"Alt+T".action.toggle-column-tabbed-display					= [];


					"Ctrl+Alt+H"												= { allow-when-locked = true; action.spawn = [ "${dms}" "ipc" "mpris" "previous" ]; };
					"Ctrl+Alt+L"												= { allow-when-locked = true; action.spawn = [ "${dms}" "ipc" "mpris" "next" ]; };
					"Ctrl+Alt+Space"											= { allow-when-locked = true; action.spawn = [ "${dms}" "ipc" "mpris" "playPause" ]; };

					"Alt+Left".action.focus-column-left							= [];
					"Alt+Down".action.focus-window-down							= [];
					"Alt+Up".action.focus-window-up								= [];
					"Alt+Right".action.focus-column-right						= [];
					"Alt+H".action.focus-column-left							= [];
					"Alt+L".action.focus-column-right							= [];
					"Alt+J".action.focus-window-down-or-column-right			= [];
					"Alt+K".action.focus-window-up-or-column-left				= [];

					"Alt+Shift+Left".action.move-column-left					= [];
					"Alt+Shift+Down".action.move-window-down					= [];
					"Alt+Shift+Up".action.move-window-up						= [];
					"Alt+Shift+Right".action.move-column-right					= [];
					"Alt+Shift+H".action.move-column-left						= [];
					"Alt+Shift+J".action.move-window-down						= [];
					"Alt+Shift+K".action.move-window-up							= [];
					"Alt+Shift+L".action.move-column-right						= [];

					"Alt+Ctrl+Left".action.focus-monitor-left					= [];
					"Alt+Ctrl+Down".action.focus-monitor-down					= [];
					"Alt+Ctrl+Up".action.focus-monitor-up						= [];
					"Alt+Ctrl+Right".action.focus-monitor-right					= [];

					"Alt+Shift+Ctrl+Left".action.move-window-to-monitor-left	= [];
					"Alt+Shift+Ctrl+Down".action.move-window-to-monitor-down	= [];
					"Alt+Shift+Ctrl+Up".action.move-window-to-monitor-up		= [];
					"Alt+Shift+Ctrl+Right".action.move-window-to-monitor-right	= [];
					"Alt+Shift+Ctrl+H".action.move-window-to-monitor-left		= [];
					"Alt+Shift+Ctrl+J".action.move-window-to-monitor-down		= [];
					"Alt+Shift+Ctrl+K".action.move-window-to-monitor-up			= [];
					"Alt+Shift+Ctrl+L".action.move-window-to-monitor-right		= [];

					"Alt+D".action.focus-workspace-down							= [];
					"Alt+U".action.focus-workspace-up							= [];
					"Alt+Shift+D".action.move-window-to-workspace-down			= [];
					"Alt+Shift+U".action.move-window-to-workspace-up			= [];

					"Alt+WheelScrollDown"										= { cooldown-ms = 150; action.focus-workspace-down = []; };
					"Alt+WheelScrollUp"											= { cooldown-ms = 150; action.focus-workspace-up = []; };
					"Alt+Ctrl+WheelScrollDown"									= { cooldown-ms = 150; action.move-column-to-workspace-down = []; };
					"Alt+Ctrl+WheelScrollUp"									= { cooldown-ms = 150; action.move-column-to-workspace-up = []; };

					"Alt+WheelScrollRight".action.focus-column-right			= [];
					"Alt+WheelScrollLeft".action.focus-column-left				= [];
					"Alt+Ctrl+WheelScrollRight".action.move-column-right		= [];
					"Alt+Ctrl+WheelScrollLeft".action.move-column-left			= [];

					"Alt+Shift+WheelScrollDown".action.focus-column-right		= [];
					"Alt+Shift+WheelScrollUp".action.focus-column-left			= [];
					"Alt+Ctrl+Shift+WheelScrollDown".action.move-column-right	= [];
					"Alt+Ctrl+Shift+WheelScrollUp".action.move-column-left		= [];

					"Alt+1".action.focus-workspace								= 1;
					"Alt+2".action.focus-workspace								= 2;
					"Alt+3".action.focus-workspace								= 3;
					"Alt+4".action.focus-workspace								= 4;
					"Alt+5".action.focus-workspace								= 5;
					"Alt+6".action.focus-workspace								= 6;
					"Alt+7".action.focus-workspace								= 7;
					"Alt+8".action.focus-workspace								= 8;
					"Alt+9".action.focus-workspace								= 9;

					"Alt+Shift+1".action.move-window-to-workspace				= 1;
					"Alt+Shift+2".action.move-window-to-workspace				= 2;
					"Alt+Shift+3".action.move-window-to-workspace				= 3;
					"Alt+Shift+4".action.move-window-to-workspace				= 4;
					"Alt+Shift+5".action.move-window-to-workspace				= 5;
					"Alt+Shift+6".action.move-window-to-workspace				= 6;
					"Alt+Shift+7".action.move-window-to-workspace				= 7;
					"Alt+Shift+8".action.move-window-to-workspace				= 8;
					"Alt+Shift+9".action.move-window-to-workspace				= 9;

					"Alt+Comma".action.consume-window-into-column				= [];
					"Alt+Period".action.expel-window-from-column				= [];

					"Alt+R".action.switch-preset-column-width					= [];
					"Alt+Return".action.switch-preset-column-width				= [];
					"Alt+Shift+R".action.reset-window-height					= [];
					"Alt+F".action.maximize-column								= [];
					"Alt+Shift+F".action.fullscreen-window						= [];
					"Alt+C".action.center-column								= [];

					"Alt+Minus".action.set-column-width							= "-10%";
					"Alt+Equal".action.set-column-width							= "+10%";

					"Alt+Shift+Minus".action.set-window-height					= "-10%";
					"Alt+Shift+Equal".action.set-window-height					= "+10%";

					"Print".action.screenshot									= [];
					"Ctrl+Print".action.screenshot-screen						= [];
					"Alt+Print".action.screenshot-window						= [];

					"Alt+Shift+q".action.spawn									= [ "systemctl" "--user" "stop" "niri" ];
					# "alt+Shift+P".acion.power-off-monitors						= true;
				};
			};
		};
	in {
		nixpkgs.overlays = [
			inputs.niri.overlays.default
		];

		imports = [
			inputs.niri-config.nixosModules.niri
			(let
				niri-cfg-modules = lib.evalModules {
					modules = [
						inputs.niri-config.lib.internal.settings-module
						nirimodule
					];
				};

				my-niri-config = niri-cfg-modules.config.programs.niri.finalConfig;
			in {
				environment.etc."niri/config.kdl".text	= my-niri-config;
				environment.variables.NIRI_CONFIG		= "/etc/niri/config.kdl";

				programs.niri = {
					# Use the package from the niri flake, not the niri-config
					package								= pkgs.niri;
					enable								= true;
				};
				services.displayManager.defaultSession	= "niri";

				# This conflicts with the gnome one
				programs.ssh.startAgent					= false;
			})
		];

		# Open the firewall port for rquickshare
		networking.firewall.allowedTCPPorts				= [ 12345 ];
	};
in {
	flake.modules.nixos.software_desktop	= module;
	flake.modules.nixos.software_niri		= module;
}

