# ~/.config/alias.d/tailscale.sh

tssh() {
    target_host=$(tailscale status | awk '!/k3s/ {print $2}' | fzf)
    ssh -i ~/.ssh/greenboard.uu -o StrictHostKeyChecking=no green@"$target_host"
}

tkx () {
    tailscale configure kubeconfig $(tailscale status | awk '/k3s-/ {print $2}' | fzf)
}