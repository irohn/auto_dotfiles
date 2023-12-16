# ~/.config/alias.d/network.sh

function sshgb() {
    target_host=$(tailscale status | awk '/ 48-b0-2d/ {print $2}' | fzf)
    ssh -i ~/.ssh/greenboard.uu -o StrictHostKeyChecking=no green@"$target_host"
}