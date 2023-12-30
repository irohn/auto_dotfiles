# ~/.config/alias.d/kubernetes.sh

alias pods="kubectl get pods --all-namespaces"
alias wp="watch -n 0.1 'kubectl get pods --all-namespaces'"

alias fl='flux logs -A'
alias fra='flux reconcile kustomization flux-system --with-source'