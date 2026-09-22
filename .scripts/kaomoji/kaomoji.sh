#!/usr/bin/env bash

version=0.2

base_dir="$HOME/.scripts/kaomoji"
kaomoji_list=$base_dir/list
hist_file="$base_dir/hist"
default_cmd="$DEFAULT_CMD"

echo_newline=${ECHO_NEWLINE:-false}
private_mode=${PRIVATE_MODE:-false}
limit_hist="$LIMIT_RECENT"

usage() {
	echo "Usage: $(basename "$0") [-t | -c | -e] [-f <filepath> ] [-p] [-P] [-D <choices>]" 1>&2
	echo
	echo "A simple kaomoji picker script for bemenu (o･ω･o)"
	echo "Invoked without arguments sends the picked kaomoji to the clipboard."
	echo
	echo " Command options (can be combined):"
	echo "  -c, --clip                 Send kaomoji choice to the clipboard. (default)"
	echo "  -e, --echo                 Only echo out the picked kaomoji."
	echo "  -n, --newline              Print a newline after the picked kaomoji."
	echo "  -p, --private              Do not save picked kaomoji to recent history."
	echo "  -P, --hist-limit <number>  Limit number of recent kaomoji to display."
	echo "  -f, --file <filepath>      Use a custom kaomoji database. Can be a url which will be retrieved."
	echo "  -v, --version              Display current script version and directory configuration."
	echo "  -h, --help                 Show this help."
	echo
	exit "$1"
}

version() {
	printf "Version: %s\nList File: %s\nHistory File: %s\n" "$version" "$kaomoji_list" "$hist_file"
	exit
}

msg() {
	printf "%s\n" "$1" >&2
}

parse_cli() {
	while getopts cD:ef:hnpP:tv-: arg "$@"; do
	case "$arg" in
		c) kaomoji_cmds+=(_clipper) ;;
		e) kaomoji_cmds+=(cat) ;;
		f) _opt_set_custom_list "${OPTARG}" ;;
		h) usage 0 ;;
		n) echo_newline=true ;;
		p) private_mode=true ;;
		P) _opt_set_hist_limit "${OPTARG}" ;;
		v) version ;;
		-)
			LONG_OPTARG="${OPTARG#*=}"
		case "$OPTARG" in
			clip) kaomoji_cmds+=(_clipper) ;;
			echo) kaomoji_cmds+=(cat) ;;
			file=?*) _opt_set_custom_list "${LONG_OPTARG}" ;;
			file*)
				_opt_set_custom_list "${*:$OPTIND:1}"
				OPTIND=$((OPTIND + 1))
			;;
			help) usage 0 ;;
			newline) echo_newline=true ;;
			private) private_mode=true ;;
			hist-limit=?*) _opt_set_hist_limit "${LONG_OPTARG}" ;;
			hist-limit*)
				_opt_set_hist_limit "${*:$OPTIND:1}"
				OPTIND=$((OPTIND + 1))
			;;
			version) version ;;
			'') break ;;
			*)
				echo "Unknown option: ${OPTARG}" 1>&2
				usage 1
			;;
		esac
		;;
		\?) exit 2 ;;
	esac
	done
	shift $((OPTIND - 1))
	OPTIND=1
}

_opt_set_custom_list() {
	kaomoji_list="$1"
}
_opt_set_hist_limit() {
	limit_hist="$1"
}

gather_emojis() {
	local result
	if [ -n "$kaomoji_list" ] && [ -f "$kaomoji_list" ]; then
		result=$(cat "$kaomoji_list")
	else
		result=$(echo "No results found")
	fi

	if [ -n "$limit_hist" ] && [ "$limit_hist" -eq 0 ]; then
		printf "%s" "$result"
		return
	fi

	printf "%s\n%s" "$(get_most_recent "$limit_hist")" "$result" | cat -n - | sort -uk2 | sort -n | cut -f2-
}

get_most_recent() {
	local limit=${1}
	local recent_file="$hist_file"
	if [ ! -f "$recent_file" ]; then
		touch "$recent_file"
	fi
	local result
	result=$(sed -e '/^$/d' "$recent_file" |
		sort |
		uniq -c |
		sort -k1rn |
		sed -e 's/^\s*//' |
		cut -d' ' -f2-)
	if [ -z "$limit" ]; then
		echo "$result"
	else
		echo "$result" | head -n "$limit"
	fi
}

add_to_recent() {
	if [ -z "$1" ]; then return; fi
	if [ ! -d "$base_dir" ]; then
		mkdir -p "$base_dir"
	fi
	echo "$1" >>"$hist_file"
}

_clipper() {
	xclip
}

_picker() {
	dmenu -l 20
}

parse_cli "$@"

[ -n "$kaomoji_list" ] || prepare_db
result=$(gather_emojis | _picker)
exit_value="$?"
[ "$private_mode" = true ] || add_to_recent "$result"

result=$(echo "$result" | sed 's/ - .*//' | tr -d '\n')

printout() {
	if [ "$echo_newline" = true ]; then
		printf "%s\n" "$*"
	else
		printf "%s" "$*"
	fi
}

case "$exit_value" in
	1)
		exit 1
	;;
	0)
		if [ ${#kaomoji_cmds[@]} -eq 0 ]; then
			if [ -n "$default_cmd" ]; then
				printout "$result" | ${default_cmd[@]}
				exit
			fi
			kaomoji_cmds+=(_clipper)
		fi
		for cmd in "${kaomoji_cmds[@]}"; do
			printout "$result" | "$cmd"
		done
	;;
	10)
		printout "$result" | _clipper
	;;
esac

exit
