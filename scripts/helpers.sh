set_tmux_option() {
	local option="$1"
	local value="$2"

	tmux set-option -gq "$option" "$value"
}

get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value="$(tmux show_option -gqv)"

	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

is_osx() {
	[ $(uname) == "Darwin" ]
}
