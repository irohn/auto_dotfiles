#!/bin/zsh

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
    awk '{print "/usr/local/bin/kubectl " "-n " $2 " describe " tolower($1) " " $3}' | sh
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

function kpf() {
    if [ -z "$1" ]; then
        echo "No pod name specified."
        return 1
    elif [ -z "$2" ]; then
        echo "Specify atleast one tunnel (local_port:remote_port)."
        return 1
    else
        echo "press Ctrl + C to stop forwarding"
        echo "Starting tunnel..."
        kubectl port-forward $(kgp $1) ${@:2}
    fi
}

function kd() {
    current_namespace="$(kubens --current)"
    if [[ "$current_namespace" == "default" ]]; then
        kubectl get all --all-namespaces --no-headers -o \
        custom-columns="KIND":.kind,"NAMESPACE":.metadata.namespace,"NAME":.metadata.name | \
        fzf --color header:italic --header 'KIND    NAMESPACE    NAME' | \
        awk '{print "/usr/local/bin/kubectl " "-n " $2 " describe " tolower($1) " " $3}' | sh
    else
        kubectl get all --no-headers -o \
        custom-columns="KIND":.kind,"NAMESPACE":.metadata.namespace,"NAME":.metadata.name | \
        fzf --color header:italic --header 'KIND    NAMESPACE    NAME' | \
        awk '{print "/usr/local/bin/kubectl " "-n " $2 " describe " tolower($1) " " $3}' | sh
    fi
}

function kl() {
    current_namespace="$(kubens --current)"
    if [[ "$current_namespace" == "default" ]]; then
        info=$(kubectl get pods --all-namespaces -o \
        jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{" "}{range .spec.containers[*]}{.name}{","}{end}{"\n"}{end}' | \
        sed 's/.$//' | column -t | \
        fzf --delimiter=" " --preview 'echo "containers:\n"{-1} | sed "s|,|\n|g" ' --preview-window='border-rounded,down,50%' --exit-0 --select-1)
        container=$(echo $info | awk '{print $NF}' | sed 's/,/\n/g' | fzf --exit-0 --select-1)
        /usr/local/bin/kubectl -n $(echo $info | awk '{print $1}') logs $(echo $info | awk '{print $2}') -c $container ${@:1}
    else
        info=$(kubectl get pods -o \
        jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{" "}{range .spec.containers[*]}{.name}{","}{end}{"\n"}{end}' | \
        sed 's/.$//' | column -t | \
        fzf --preview 'echo "containers:\n"{-1} | sed "s|,|\n|g" ' --preview-window='border-rounded,down,50%' --exit-0 --select-1)
        container=$(echo $info | awk '{print $NF}' | sed 's/,/\n/g' | fzf --exit-0 --select-1)
        /usr/local/bin/kubectl -n $(echo $info | awk '{print $1}') logs $(echo $info | awk '{print $2}') -c $container ${@:1}
    fi
}
