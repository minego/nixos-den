# TODO
#	- Get configured on macos and through nix
#	- Wrap git and make etc with plugins?
#	- direnv

$env.config.show_banner					= false
$env.config.edit_mode					= 'vi'
$env.config.buffer_editor				= "nvim"

$env.config.history.file_format			= "sqlite"
$env.config.history.isolation			= false
$env.config.history.sync_on_enter		= true

$env.config.rm.always_trash				= false

$env.config.use_kitty_protocol			= true
$env.config.display_errors.exit_code	= false		# Let starship display it
$env.config.footer_mode					= "auto"

$env.config.table.mode					= "light"

use std/dirs


# Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# Carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir $"($nu.cache-dir)"
carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
source $"($nu.cache-dir)/carapace.nu"


# direnv
use std/config *

# Initialize the PWD hook as an empty list if it doesn't exist
$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

$env.config.hooks.env_change.PWD ++= [{||
	if (which direnv | is-empty) {
		# If direnv isn't installed, do nothing
		return
	}

	direnv export json | from json | default {} | load-env

	# If direnv changes the PATH, it will become a string and we need to re-convert it to a list
	$env.PATH = do (env-conversions).path.from_string $env.PATH
}]

