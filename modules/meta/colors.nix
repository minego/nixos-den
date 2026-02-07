{ lib, ... }:
let
	inherit (lib) mkOption types;
in
{
	# This module is base for all user configs.
	den.base.host = { ... }: {
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

			type = types.attrsOf (
				types.submodule {
					options = {
						light = mkOption {
							type		= types.lazyAttrsOf types.raw;
							default		= { };
						};
						dark = mkOption {
							type		= types.lazyAttrsOf types.raw;
							default		= { };
						};
					};
				}
			);
		};
	};
}
