let
	module = { inputs, pkgs, lib, ... }: {
		nixpkgs.overlays = [
			(self: super: {
				zsh-vi-mode = super.zsh-vi-mode.overrideDerivation (oldAttrs: {
					src = inputs.zsh-vi-mode;
				});
			})
		];

		environment.systemPackages = with pkgs; [
			zsh
			zsh-syntax-highlighting
			zsh-vi-mode
			zsh-nix-shell
		];

		programs = {
			zsh = {
				enable				= true;
				enableCompletion	= true;

				shellAliases = {
					fucking			= "sudo";

					":q"			= "exit";
					":qall"			= "exit";
					":e"			= "vi";

					open			= lib.mkIf pkgs.stdenv.isLinux "xdg-open";

					ls				= "${pkgs.eza}/bin/eza";
				};
				histFile			= "$HOME/.history";

				setOptions			= [
					"NoHUP"
					"autocd"

					"AppendHistory"

					"HistReduceBlanks"
					"HistIgnoreSpace"
					"HistFindNoDups"
					"HistIgnoreDups"
					"IncAppendHistory"
					"ShareHistory"
					"ExtendedHistory"
					
					"MarkDirs"
					"ListTypes"
					"LongListJobs"
					
					"CBases"			# Print hex numbers properly
					"OctalZeroes"		# Print octal numbers properly
					
					"cshNULLGlob"		# Only complain about no matches if NONE of them match
					"NumericGlobSort"	# Sort filenames with numbers numerically
		 
				];

				shellInit= ''
					# Prevent prompting the user to create ~/.zshrc
					zsh-newuser-install() { :; }
					'';

				interactiveShellInit= ''
					if command -v nix-your-shell > /dev/null; then
						nix-your-shell zsh | source /dev/stdin
					fi
					source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
					
					# Use viins keymap as the default.
					bindkey -v
					
					# Allow completion to find matches regardless of case
					zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
					
					# Rehash automatically
					zstyle ':completion:*' rehash true
					
					unsetopt MenuComplete	# I don't really like the menu, and it has a habit of
					unsetopt AutoMenu		# selecting the first match automatically.  I hate that.
					
					unsetopt Beep			# SHUT UP!
					
					# Only show entries in the history that match the current line
					autoload up-line-or-beginning-search
					autoload down-line-or-beginning-search
					zle -N up-line-or-beginning-search
					zle -N down-line-or-beginning-search
					bindkey "^[[A" up-line-or-beginning-search
					bindkey "^[[B" down-line-or-beginning-search
					bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
					bindkey "$terminfo[kcud1]" down-line-or-beginning-search
					bindkey -M vicmd "k" up-line-or-beginning-search
					bindkey -M vicmd "j" down-line-or-beginning-search
					
					EXA_ICON_SPACING=2;
					
					export HISTFILESIZE=1000000000
					export HISTSIZE=1000000000
					export SAVEHIST=1000000000
					
					# nix-index
					source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

					# Carapace
					autoload -U compinit && compinit
					export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
					zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
					source <(carapace _carapace)

					'';
			};

			direnv = {
				enable						= true;
				nix-direnv.enable			= true;
				enableZshIntegration		= true;
			};
		};

		# Needed for auto completion to work for zsh
		environment.pathsToLink				= [ "/share/zsh" ];
	};
in {
	flake.modules.nixos.software = module;
	flake.modules.nixos.software_shell_zsh = module;
}
