# ~/.config/alias.d/kubernetes.sh

kubectl_bin_path="$(which kubectl || printf %s kubectl)"
alias pods="$kubectl_bin_path get pods --all-namespaces"

function tkx () {
    tailscale configure kubeconfig $(tailscale status | awk '/k3s-/ {print $2}' | fzf)
}