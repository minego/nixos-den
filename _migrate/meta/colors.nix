{ lib, ... }:
let
	inherit (lib) mkOption types;
in
{
	# This module is base for all user configs.
	den.base.host = { ... }: let
		colorsOption = mkOption {
			type = types.submodule {
				options = {
					black	= mkOption { type = types.str; };
					red		= mkOption { type = types.str; };
					green	= mkOption { type = types.str; };
					yellow	= mkOption { type = types.str; };
					blue	= mkOption { type = types.str; };
					magenta	= mkOption { type = types.str; };
					cyan	= mkOption { type = types.str; };
					white	= mkOption { type = types.str; };
					grey	= mkOption { type = types.str; };
				};
			};
		};
	in {
		options.colors = mkOption {
			default = {
				light = {
					black	= "000000";
					red		= "ff2a6d";
					green	= "bcea3b";
					yellow	= "faff00";
					blue	= "02a9ea";
					magenta	= "A61B47";
					cyan	= "05d9e8";
					white	= "999999";
					grey	= "0f0f0f";
				};

				dark = {
					black	= "222222";
					red		= "D9245D";
					green	= "96BA2F";
					yellow	= "D5D900";
					blue	= "0285B8";
					magenta	= "8C173C";
					cyan	= "04ACB8";
					white	= "ffffff";
					grey	= "090909";
				};
			};

			type = types.submodule {
				options = {
					light	= colorsOption;
					dark	= colorsOption;
				};
			};
		};
	};
}
