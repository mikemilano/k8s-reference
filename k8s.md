# Kubernetes

## Context & Namespace Management

- [kubectx & kubens](https://github.com/ahmetb/kubectx): K8s context and namespace switching tools. (brew)
- [kube-ps1](https://github.com/jonmosco/kube-ps1): Adds K8s context and namespace to OSX command prompt. (brew)

The following is required in your shell init for `kube-ps1`.
```bash
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
export PS1='$(kube_ps1)'$PS1
```

## Aliases

```bash
alias k="kubectl"
alias kx="kubectx"
alias kns="kubectl ns"
```
