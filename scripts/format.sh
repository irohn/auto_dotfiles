SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# source colors
source "$SCRIPT_DIR"/scripts/colors.sh

# Prefixes
function prefix_info() {
    printf "[ ${white}INFO${color_off} ]"
}

function prefix_ok() {
    printf "[  ${green}OK${color_off}  ]"
}

function prefix_err() {
    printf "[ ${red}ERR${color_off}  ]"
}

function prefix_warn() {
    printf "[ ${yellow}WARN${color_off} ]"
}

function prefix_skip() {
    printf "[ ${cyan}SKIP${color_off} ]"
}

# Markings
function mark() {
    printf "${iyellow}${@}${color_off}"
}

function hyperlink() {
    printf "${ucyan}${@}${color_off}"
}

function task_title() {
    printf "${bwhite}${1}:${color_off}"
}