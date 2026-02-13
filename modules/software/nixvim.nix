let 
	module = { inputs, pkgs, ... }: let
		nvim		= pkgs.neovim;
		nvimcmd		= "${nvim}/bin/nvim";

		pager	= (pkgs.writeShellScriptBin "pager" ''
			TMPFILE=$(mktemp)

			# Trap bash's EXIT pseudo signal to cleanup
			trap 'rm -f "$TMPFILE"' EXIT

			# Read from stdin into the temp file
			cat > "$TMPFILE"

			if [[ $(cat "$TMPFILE" | wc -l) -le $(tput lines) ]]; then
				# The entire output will fit on one screen, so don't bother with
				# launching neovim.

				exec cat "$TMPFILE"
			else
				exec ${nvimcmd}								\
					+'set eventignore=FileType'				\
					+'nnoremap q ZQ'						\
					+'set nonumber norelativenumber'		\
					+'set nowrap signcolumn=auto'			\
					+'set nomodified nolist'				\
					+'TermHl'								\
					+'set nonumber norelativenumber'		\
					+'set nowrap signcolumn=auto'			\
					+'set nomodified nolist'				\
					+'$' -
			fi

			# When neovim 0.12 is available, this should work instead of the
			# 'TermHl' user command
			# +'call nvim_open_term(0, {})'
		'');
	in {
		nixpkgs.overlays = [
			inputs.nixvim.overlays.default
		];

		environment.shellAliases = {
			vi				= nvimcmd;
			vim				= nvimcmd;
		};

		environment.variables = {
			KEYTIMEOUT		= "1";
			VISUAL			= nvimcmd;
			EDITOR			= nvimcmd;
			SUDO_EDITOR		= nvimcmd;
			LC_CTYPE		= "C";
			PAGER			= "pager";
			pager			= "pager";
			GIT_PAGER		= "pager";
		};

		environment.systemPackages = [
			nvim
			pager
		];
	};
in {
	flake.modules.nixos.software		= module;
	flake.modules.nixos.software_nixvim	= module;
}
