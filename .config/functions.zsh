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
        jq -r --arg pattern "$1" '[.items[] | select(.metadata.name | test($pattern)).metadata | "-n " + .namespace + " " + .name][0]'
    fi
}

function kgd() {
    if [ -z "$1" ]; then
        kubectl get deployments --all-namespaces -o wide
    else
        kubectl get deployments --all-namespaces -o json | \
        jq -r --arg pattern "$1" '[.items[] | select(.metadata.name | test($pattern)).metadata | "-n " + .namespace + " " + .name][0]'
    fi
}

function kgs() {
    if [ -z "$1" ]; then
        kubectl get secrets --all-namespaces -o wide
    else
        kubectl get secrets --all-namespaces -o json | \
        jq -r --arg pattern "$1" '[.items[] | select(.metadata.name | test($pattern)).metadata | "-n " + .namespace + " " + .name][0]'
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

function kgpc() {
    kubectl get pods --all-namespaces -o json | jq -r --arg pod_name $1 --arg container $2 '.items[] | select(.metadata.name | test($pod_name)).spec.containers[] | select(.name | test($container)).name'
}

function kl() {
    if [ -z "$1" ]; then
        echo "No pod name specified."
    elif [ -z "$2" ]; then
        echo "No container name specified, logging all containers..."
        kubectl logs $(kgp $1) --all-containers ${@:2} 
    else
        kubectl logs $(kgp $1) -c $(kgpc $1 $2) ${@:3}  
    fi
}