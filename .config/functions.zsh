#!/bin/zsh

function kga() {
    if [ -z "$1" ]; then
        kubectl get all --all-namespaces -o wide
    else
        kubectl get all -n $1 -o wide
    fi
}

function kgp() {
    if [ -z "$1" ]; then
        kubectl get pods --all-namespaces -o wide
    else
        kubectl get pods --all-namespaces -o json | \
        jq -r --arg pattern "$1" \
        '[.items[] | 
        select(.metadata.name | test($pattern)).metadata | "-n " + .namespace + " " + .name][0]'
    fi
}

function kgpc() {
    if [ -z "$1" ]; then
        echo "No pod name specified."
        return 1
    elif [ -z "$2" ]; then
        echo "No container name specified."
        return 1
    else
        kubectl get pods --all-namespaces -o json | \
        jq -r --arg pod_name "$1" --arg container "$2" \
        '[.items[] | 
        select(.metadata.name | test($pod_name)) | 
        select(.spec.containers[].name | test($container)) | 
        "-n " + .metadata.namespace + " " + .metadata.name + " -c " + .spec.containers[].name | 
        select(test($container))][0]'
    fi
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

function kdp() {
    kubectl describe pod $(kgp $1)
}

function kge() {
    if [ -z "$1" ]; then
        kubectl get events --all-namespaces -o wide
    else
        kubectl get events -n $1 -o wide
    fi
}

function kl() {
    if [ -z "$1" ]; then
        echo "No pod name specified."
        return 1
    elif [ -z "$2" ]; then
        echo "No container name specified, logging all containers..."
        kubectl logs $(kgp $1) --all-containers ${@:2}
    else
        kubectl logs $(kgpc $1 $2) ${@:3}
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

function thingsboard() {
    kpf thingsboard ${1:-9090}:9090
}

function dashboard() {
    kpf dashboard-viewer ${1:-8000}:8000
}

function servicetool() {
    kpf service-tool ${1:-8502}:8502
}