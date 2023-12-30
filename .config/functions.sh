# ~/.config/functions.sh

function sshgb() {
    target_host=$(tailscale status | awk '/ 48-b0-2d/ {print $2}' | fzf)
    ssh -i ~/.ssh/greenboard.uu -o StrictHostKeyChecking=no green@"$target_host"
}

function kx () {
    tailscale configure kubeconfig $(tailscale status | awk '/k3s-/ {print $2}' | fzf)
}

function pods () {
    current_namespace="$(kubens --current)"
    if [[ "$current_namespace" == "default" ]]; then
        kubectl get pods --all-namespaces
    else
        kubectl get pods
    fi
}

function wp () {
    current_namespace="$(kubens --current)"
    if [[ "$current_namespace" == "default" ]]; then
        watch -n 0.1 "kubectl get pods --all-namespaces"
    else
        watch -n 0.1 "kubectl get pods"
    fi
}

function kga() {
    kubectl get all --all-namespaces --no-headers -o \
    custom-columns="KIND":.kind,"NAMESPACE":.metadata.namespace,"NAME":.metadata.name | \
    fzf --color header:italic --header 'KIND    NAMESPACE    NAME' | \
    awk -v kubectl_bin_path=kubectl '{print kubectl_bin_path" " "-n " $2 " describe " tolower($1) " " $3}' | sh
}

function kgd() {
    if [ -z "$1" ]; then
        kubectl get deployments --all-namespaces -o wide
    else
        kubectl get deployments --all-namespaces -o json | \
        jq -r --arg pattern "$1" '[.items[] | 
        select(.metadata.name | test($pattern)).metadata | "-n " + .namespace + " " + .name][0]'
    fi
}

function kgs() {
    if [ -z "$1" ]; then
        kubectl get secrets --all-namespaces -o wide
    else
        kubectl get secrets --all-namespaces -o json | \
        jq -r --arg pattern "$1" '[.items[] | 
        select(.metadata.name | test($pattern)).metadata | "-n " + .namespace + " " + .name][0]'
    fi
}

function kd() {
    if ! [ -z "$1" ]; then
        pod_pattern="$1"
        info=$(kubectl get pods --all-namespaces -o json | \
        jq -r --arg pattern "$pod_pattern" \
        '[.items[] | select(.metadata.name | test($pattern)) | .kind + " " + .metadata.namespace + " " + .metadata.name][0]')
        args="describe $(echo $info | awk '{print $1}') -n ${info#* }"
        echo "kubectl $args" | tr '[:upper:]' '[:lower:]' | sh
        return 0
    else
        current_namespace="$(kubens --current)"
        if [[ "$current_namespace" == "default" ]]; then
            kubectl get all --all-namespaces --no-headers -o \
            custom-columns="KIND":.kind,"NAMESPACE":.metadata.namespace,"NAME":.metadata.name | \
            fzf --color header:italic --header 'KIND    NAMESPACE    NAME' | \
            awk -v kubectl_bin_path=kubectl '{print kubectl_bin_path" " "-n " $2 " describe " tolower($1) " " $3}' | sh
        else
            kubectl get all --no-headers -o \
            custom-columns="KIND":.kind,"NAMESPACE":.metadata.namespace,"NAME":.metadata.name | \
            fzf --color header:italic --header 'KIND    NAMESPACE    NAME' | \
            awk -v kubectl_bin_path=kubectl '{print kubectl_bin_path" " "-n " $2 " describe " tolower($1) " " $3}' | sh
        fi
    fi
}

function kl() {
    if ! [ -z "$1" ]; then
        pod_pattern="$1"
        if ! [ -z "$2" ]; then
            container_pattern="$2"
            shift
            args=$(kubectl get pods --all-namespaces -o json | \
            jq -r --arg pod_name "$pod_pattern" --arg container "$container_pattern" \
            '[.items[] | 
            select(.metadata.name | test($pod_name)) | 
            select(.spec.containers[].name | test($container)) | 
            .metadata.namespace + " " + .metadata.name + " -c " + .spec.containers[].name | 
            select(test($container))][0]')
            echo "kubectl logs -n $args ${@:2}" | sh
            return 0
        else
            info=$(kubectl get pods --all-namespaces -o json | \
            jq -r --arg pattern "$pod_pattern" \
            '[.items[] | 
            select(.metadata.name | test($pattern)).metadata | .namespace + " " + .name][0]')
            container_name=`kubectl get pods -n ${info% *} ${info#* } -o \
            jsonpath='{range .spec.containers[*]}{.name}{"\n"}{end}' | column -t | \
            fzf --preview 'echo {}' --preview-window='border-rounded,down,50%' --exit-0 --select-1`
            args="$info $container_name"
        fi
        shift
        echo "kubectl logs -n $args" | sh
        return 0
    else
        current_namespace="$(kubens --current)"
        if [[ "$current_namespace" == "default" ]]; then
            info=$(kubectl get pods --all-namespaces -o \
            jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{" "}{range .spec.containers[*]}{.name}{","}{end}{"\n"}{end}' | \
            sed 's/.$//' | column -t | \
            fzf --preview 'echo "containers:\n"{-1} | sed "s|,|\n|g" ' --preview-window='border-rounded,down,50%' --exit-0 --select-1)
            container=$(echo $info | awk '{print $NF}' | sed 's/,/\n/g' | fzf --exit-0 --select-1)
            kubectl -n $(echo $info | awk '{print $1}') logs $(echo $info | awk '{print $2}') -c $container
        else
            info=$(kubectl get pods -o \
            jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{" "}{range .spec.containers[*]}{.name}{","}{end}{"\n"}{end}' | \
            sed 's/.$//' | column -t | \
            fzf --preview 'echo "containers:\n"{-1} | sed "s|,|\n|g" ' --preview-window='border-rounded,down,50%' --exit-0 --select-1)
            container=$(echo $info | awk '{print $NF}' | sed 's/,/\n/g' | fzf --exit-0 --select-1)
            kubectl -n $(echo $info | awk '{print $1}') logs $(echo $info | awk '{print $2}') -c $container
        fi
    fi
}

function kpf() {
    if ! [ -z "$1" ]; then
        pod_pattern="$1"
        if [ -z "$2" ]; then
            echo "Ports to forward <local_port>:<remote_port> (e.g. 8080:80 8081:443)"
            read ports
            echo "Address: 127.0.0.1:$(echo ${ports%:*})"
        else
            ports="${@:2}"
            echo "Address: 127.0.0.1:$(echo ${ports%:*})"
        fi
        cmd="kubectl port-forward `kubectl get pods --all-namespaces -o json | \
        jq -r --arg pattern "$pod_pattern" \
        '[.items[] | 
        select(.metadata.name | test($pattern)).metadata | "-n " + .namespace + " " + .name][0]'` $ports"
        echo "$cmd" | sh
    else
        current_namespace="$(kubens --current)"
        if [[ "$current_namespace" == "default" ]]; then
            info=$(kubectl get pods --all-namespaces -o \
            jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' | \
            column -t | \
            fzf --preview 'echo "Pod: "{2}' --preview-window='border-rounded,down,50%' --exit-0 --select-1)
            echo "Ports to forward <local_port>:<remote_port> (e.g. 8080:80 8081:443)"
            read ports
            echo "Address: 127.0.0.1:$(echo ${ports%:*})"
            echo "kubectl port-forward -n $info $ports" | sh
        else
            info=$(kubectl get pods -o \
            jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}' | \
            column -t | \
            fzf --preview 'echo "Pod: "{2}' --preview-window='border-rounded,down,50%' --exit-0 --select-1)
            echo "Ports to forward <local_port>:<remote_port> (e.g. 8080:80 8081:443)"
            read ports
            echo "Address: 127.0.0.1:$(echo ${ports%:*})"
            echo "kubectl port-forward -n $info $ports" | sh
        fi
    fi
}

function sf() {
    username=${1:-$(users | tr " " "\n" | uniq | fzf --print-query --header="Select or type a username:" | tr -d '\n' | sed '/^$/d')}
    host_address=${2:-$(tailscale status | awk '/ 48-b0-2d/ {print $2}' | fzf --print-query --header="Select or type a hostname / IP:" | tr -d '\n' | sed '/^$/d')}
    dev_dir_name="/tmp/`whoami`/`basename \"$PWD\"`"
    rsync -av -e "ssh -i ~/.ssh/greenboard.uu -F /dev/null" --rsync-path="mkdir -p $dev_dir_name && rsync" --exclude='.git' --exclude='.github' \
        `pwd`/ $username@$host_address:$dev_dir_name
    echo "Files synced into $dev_dir_name"
}

