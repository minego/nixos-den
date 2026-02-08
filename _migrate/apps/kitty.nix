{ ... }: {
	minego.apps._.kitty = { host, ... }: {
		nixos = { pkgs, lib, config, ... }: {
			options.kitty = {
				fontSize = lib.mkOption {
					description		= "The font size to use for the kitty terminal";
					default			= 11;
					type			= lib.types.int;
				};
			};

			config.environment.etc = {
				"xdg/kitty/kitty.conf".text = ''
                    font_family							Monaspace Neon
                    font_size							${toString config.kitty.fontSize}
                    
                    # Shell integration is sourced and configured manually
                    shell_integration					no-rc
                    
                    allow_remote_control				yes
                    background							#${host.colors.light.black}
                    background_opacity					1
                    clipboard_control					write-clipboard write-primary read-clipboard read-primary
                    color0								#${host.colors.light.black}
                    color1								#${host.colors.light.red}
                    color2								#${host.colors.light.green}
                    color3								#${host.colors.light.yellow}
                    color4								#${host.colors.light.blue}
                    color5								#${host.colors.light.magenta}
                    color6								#${host.colors.light.cyan}
                    color7								#${host.colors.light.white}
                    color8								#${host.colors.dark.black}
                    color9								#${host.colors.dark.red}
                    color10								#${host.colors.dark.green}
                    color11								#${host.colors.dark.yellow}
                    color12								#${host.colors.dark.blue}
                    color13								#${host.colors.dark.magenta}
                    color14								#${host.colors.dark.cyan}
                    color15								#${host.colors.dark.white}
                    confirm_os_window_close				0
                    copy_on_select						no
                    cursor								#ff2a6d
                    cursor_shape						block
                    cursor_text_color					#111112
                    enable_audio_bell					no
                    focus_follows_mouse					no
                    foreground							#eeeeee
                    inactive_text_alpha					0.9
                    initial_window_height				1080
                    initial_window_width				1920
                    kitty_mod							ctrl+shift
                    linux_display_server				wayland
                    listen_on							unix:/tmp/kitty.sock
                    macos_option_as_alt					yes
                    macos_quit_when_last_window_closed	yes
                    macos_traditional_fullscreen		no
                    remember_window_size				no
                    scrollback_lines					2000
                    selection_background				#${host.colors.dark.white}
                    selection_foreground				#${host.colors.light.black}
                    sync_to_monitor						yes
                    term								xterm-kitty
                    url_color							#ff2a6d
                    url_style							curly
                    
                    map alt+shift+c						copy_to_clipboard
                    map alt+shift+v						paste_from_clipboard
                    map ctrl+insert						copy_to_clipboard
                    map kitty_mod+backspace				change_font_size all 0
                    map kitty_mod+c						copy_to_clipboard
                    map kitty_mod+d						scroll_page_down
                    map kitty_mod+down					scroll_line_down
                    map kitty_mod+e						new_window
                    map kitty_mod+equal					change_font_size all +1.0
                    map kitty_mod+h						show_scrollback
                    map kitty_mod+j						scroll_line_down
                    map kitty_mod+k						scroll_line_up
                    map kitty_mod+minus					change_font_size all -1.0
                    map kitty_mod+o						pass_selection_to_program
                    map kitty_mod+s						paste_from_selection
                    map kitty_mod+u						scroll_page_up
                    map kitty_mod+up					scroll_line_up
                    map kitty_mod+v						paste_from_clipboard
                    map shift+insert					paste_from_clipboard
                    map super+c							copy_to_clipboard
                    map super+v							paste_from_clipboard
                    
                    font_features						MonaspaceNeon-Light        +dlig +calt +liga +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07
                    font_features						MonaspaceNeon-Regular      +dlig +calt +liga +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07
                    font_features						MonaspaceNeon-Bold         +dlig +calt +liga +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07
                    font_features						MonaspaceNeon-Italic       +dlig +calt +liga +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07
                    font_features						MonaspaceNeon-Bold-Italic  +dlig +calt +liga +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07
                    '';
				"xdg/kitty/kitty.app.png".source	= ./../../assets/kitty.app.png;
			};
			config.environment.systemPackages = [
					pkgs.kitty
				];
		};
	};
}

