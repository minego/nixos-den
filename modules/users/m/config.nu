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

# $env.config.table.mode					= "light"

use std/dirs


# Starship
$env.STARSHIP_SHELL = "nu"
load-env {
    STARSHIP_SESSION_KEY: (random chars -l 16)
    PROMPT_MULTILINE_INDICATOR: (
        ^$env.STARSHIP_BIN prompt --continuation
    )
    PROMPT_INDICATOR: ""

    PROMPT_COMMAND: {||
        (
            # The initial value of `$env.CMD_DURATION_MS` is always `0823`,
			# which is an official setting.
            # See https://github.com/nushell/nushell/discussions/6402#discussioncomment-3466687.
            let cmd_duration = if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS };
            ^$env.STARSHIP_BIN prompt
                --cmd-duration $cmd_duration
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
                ...(
                    if (which "job list" | where type == built-in | is-not-empty) {
                        ["--jobs", (job list | length)]
                    } else {
                        []
                    }
                )
        )
    }

    config: ($env.config? | default {} | merge {
        render_right_prompt_on_last_line: true
    })

    PROMPT_COMMAND_RIGHT: {||
        (
            let cmd_duration = if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS };
            ^$env.STARSHIP_BIN prompt
                --right
                --cmd-duration $cmd_duration
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
                ...(
                    if (which "job list" | where type == built-in | is-not-empty) {
                        ["--jobs", (job list | length)]
                    } else {
                        []
                    }
                )
        )
    }
}

# Carapace
$env.PATH = ($env.PATH | split row (char esep) | where { $in != "/home/m/.config/carapace/bin" } | prepend "/home/m/.config/carapace/bin")

def --env get-env [name] { $env | get $name }
def --env set-env [name, value] { load-env { $name: $value } }
def --env unset-env [name] { hide-env $name }

let carapace_completer = {|spans|
	load-env {
		CARAPACE_SHELL_BUILTINS: (help commands | where category != "" | get name | each { split row " " | first } | uniq  | str join "\n")
		CARAPACE_SHELL_FUNCTIONS: (help commands | where category == "" | get name | each { split row " " | first } | uniq  | str join "\n")
	}

	# if the current command is an alias, get it's expansion
	let expanded_alias = (scope aliases | where name == $spans.0 | $in.0?.expansion?)

	# overwrite
	let spans = (if $expanded_alias != null  {
		# put the first word of the expanded alias first in the span
		$spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
	} else {
		$spans | skip 1 | prepend ($spans.0)
	})

	carapace $spans.0 nushell ...$spans
		| from json
}

mut current = (($env | default {} config).config | default {} completions)
$current.completions = ($current.completions | default {} external)
$current.completions.external = ($current.completions.external
	| default true enable
	# backwards compatible workaround for default, see nushell #15654
	| upsert completer { if $in == null { $carapace_completer } else { $in } })

$env.config = $current
   

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

