# ~/.config/alias.d/tailscale.sh


clusters_dir="$HOME/greeneye/rt-versions/clusters"

match_clusters() {
    local pattern="$1"
    local file_path sprayer_group boom_location cluster_name

    for file_path in $(find "$clusters_dir" -type f -name "cluster-vars-cm.yaml"); do
        sprayer_group=$(awk '/SPRAYER_GROUP:/ {print $2}' "$file_path" | tr -d '\r')
        boom_location=$(awk '/BOOM_LOCATION:/ {print $2}' "$file_path" | tr -d '\r')
        cluster_name=$(awk '/CLUSTER_NAME:/ {print $2}' "$file_path" | tr -d '\r')

        case "$sprayer_group-$boom_location" in
            *"$pattern"*)
                echo "$cluster_name    $sprayer_group-$boom_location"
                ;;
        esac
    done
}

tssh() {
    matches=$(match_clusters "$1")
    cluster=$(printf $matches | fzf --select-1 | cut -d' ' -f1)
    target_host=$(tailscale status | awk '!/k3s-/ {print $2}' | grep -m 1 "$cluster")
    ssh -i ~/.ssh/greenboard.uu -o StrictHostKeyChecking=no green@"$target_host"
}

tkx () {
    local matches=$(match_clusters "$1")
    local cluster=$(printf $matches | fzf --select-1 | cut -d' ' -f1)
    local target_ctx=$(tailscale status | awk '/k3s-/ {print $2}' | grep -m 1 "$cluster")
    tailscale configure kubeconfig "$target_ctx"
}

testssh() {

    matches=$(match_clusters "$1")
    printf "$matches\n" | fzf | cut -d' ' -f1
    
}
