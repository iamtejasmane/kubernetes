# Kubernetes Commands and Learnings

Welcome to this collection of Kubernetes commands and learnings. This README contains a compilation of useful commands for managing Kubernetes clusters and understanding its core concepts.

# Core Concepts

### Nodes and Cluster Information

- Get all nodes in the cluster: `kubectl get nodes`
- Check Kubernetes version: `kubectl version`
- Get detailed information about nodes: `kubectl get nodes -o wide`

### Pods

- List all pods: `kubectl get pods`
- Get information about a specific pod: `kubectl get pods <pod>`
- Create a new pod with an image: `kubectl run nginx --image=nginx`
- Describe a pod: `kubectl describe pod <pod>-<ID>`
- Check image used in a pod: `kubectl describe pod <podWithID> | grep -i image`
- Delete a pod: `kubectl delete pod <pod>`
- Apply or create pod from a YAML file: `kubectl apply -f <file>`

### Replication Controller / ReplicaSet

- Create a replication controller or replicaset: `kubectl create -f <definition-file-yml>`
- Get replicaset: `kubectl get replicaset`
- Get version for the replicaset: `kubectl explain replicaset | grep VERSION`
- Replace or update existing definition: `kubectl replace -f <definition-file-yaml>`
- Scale replica using command line: `kubectl scale --replicas={count} <definition-file>`
- Delete replica set and underlying pods: `kubectl delete replicaset <replicaset-name>`
- Describe replicaset: `kubectl describe replicaset <replicaset-name>`

### Deployments

- Get deployments: `kubectl get deployments`
- Describe a deployment: `kubectl describe deployment <deployment-name>`
- Check deployment rollout status: `kubectl rollout status deployment/<deployment-name>`
- View deployment rollout history: `kubectl rollout history deployment/<deployment-name>`
- Change image of a deployment: `kubectl set image deployment/<deployment-name> nginx=nginx:1.9.1`
- Undo deployment changes: `kubectl rollout undo deployment/myapp-deployment`

### Services

- Get services: `kubectl get services`
- Describe a service: `kubectl describe service <service-name>`
- Expose a pod as a service: `kubectl expose pod <pod> --port=6379 --name=redis-service --dry-run=client -o yaml`

### Namespaces

- Create a namespace: `kubectl create namespace <name>`
- Set a specific namespace as default: `kubectl config set-context $(kubectl config current-context) --namespace=<namespace-name>`
- Get pods in a specific namespace: `kubectl get pods --namespace=<namespace-name>`
- Get all pods in all namespaces: `kubectl get pods --all-namespaces`

# Scheduling

### Labels and Selectors

- Filter pods with labels: `kubectl get pods --selector app=App1`

### Taints and Tolerations

- Taint a node: `kubectl taint nodes node-name key=value:taint-effect`
- Add tolerations to a pod: Include in pod's spec

### Node Selector

- Label a node: `kubectl label nodes node-name label-key=label-value`

### Node Affinity

- Define node affinity in pod's spec

### Daemon Sets

- Get daemon sets: `kubectl get daemonsets`
- Describe daemon sets: `kubectl describe daemonset <daemonset-name>`

## Monitoring

- Start metrics server on Minikube: `minikube addons enable metrics-server`
- Deploy metrics server on other environments

## Logs

- Get logs: `kubectl logs -f <log-pod-name> <container-name>`

## Rollout and Versioning

- Check rollout status: `kubectl rollout status deployment/<deployment-name>`
- View rollout history: `kubectl rollout history deployment/<deployment-name>`
- Undo a change: `kubectl rollout undo deployment/<deployment-name>`

## Commands and Arguments

- Specify commands and arguments in a pod's spec

## Environment Variables

- Set environment variables: In pod's spec, use `env` or `envFrom`

## Config Maps

- Create config map: `kubectl create configmap <config-name> --from-literal=<key>=<value>`
- Use config map in pod's spec

## Secrets

- Create secret: `kubectl create secret generic <secret-name> --from-literal=<key>=<value>`
- Use secrets in pod's spec

## Namespace

- Create namespace: `kubectl create namespace <name>`
- Set a specific namespace as default: `kubectl config set-context $(kubectl config current-context) --namespace=<namespace-name>`
- Get pods in a specific namespace: `kubectl get pods --namespace=<namespace-name>`
- Get all pods in all namespaces: `kubectl get pods --all-namespaces`

# Cluster Maintenance

This section provides an overview of Kubernetes maintenance, security practices, and TLS certificate management. Be sure to refer to the original script for detailed commands and explanations.

## Node Maintenance

During maintenance, you may need to move all the pods from a specific node to other nodes. Here are the steps:

- Empty the node: `kubectl drain <node-name> --ignore-daemonsets`

  The `--ignore-daemonsets` flag is used to ignore daemonsets and makes the node unschedulable, ensuring no new pods are scheduled on it. This command might not work if the pods are not managed by specific controllers.

  If the command doesn't work, you can use `--force`, but be cautious as it may result in permanent loss of pods.

- Make a node un-schedulable: `kubectl cordon <node-name>`

- Make a node available again: `kubectl uncordon <node-name>`

## Cluster Upgrade

To upgrade your Kubernetes cluster, follow these steps:

1. Upgrade Master Node:

   - Update package list: `apt update`
   - Install kubeadm with the desired version: `apt install kubeadm=1.20.0-00`
   - Upgrade Kubernetes control plane: `kubeadm upgrade apply v1.20.0`
   - Update kubelet version: `apt install kubelet=1.20.0-00`
   - Restart kubelet: `systemctl restart kubelet`

2. Upgrade Worker Node:

   - Drain the node and make it unschedulable: `kubectl drain <node-name>`
   - SSH into the node
   - Update package list: `apt update`
   - Upgrade kubelet: `apt install kubeadm=1.20.0-00`
   - Upgrade node configuration: `kubeadm upgrade node`
   - Update kubelet version: `apt install kubelet=1.20.0-00`
   - Restart kubelet after upgrade: `systemctl restart kubelet`
   - Logout or exit
   - Make the node schedulable: `kubectl uncordon <node-name>`

# Backup and Restore

To take a backup of all resources into a definition file:

```bash
kubectl get all --all-namespaces -o yaml > all-deploy-services.yaml
```

For more advanced backup and restore, consider using tools like Velero to back up your Kubernetes cluster.

## Etcd Backup and Restore

Etcd is crucial for storing the state of your cluster. To take an Etcd snapshot:

```bash
etcdctl snapshot save snapshot.db
```

To restore your cluster from a snapshot:

1. Stop kube-apiserver: `service kube-apiserver stop`
2. Restore snapshot: `etcdctl snapshot restore snapshot.db --data-dir /var/lib/etcd-from-backup`
3. Reload service daemon: `systemctl daemon-reload`
4. Restart etcd service: `service etcd restart`
5. Start kube-apiserver: `service kube-apiserver start`

Make sure to set `ETCDCTL_API=3` to use etcdctl for backup and restore tasks.

# Security

### Authentication

To pass basic username and password to kube-apiserver for authentication, use the `--basic-auth-file` flag or the `--token-auth-file` flag for static token files. However, using basic auth is not recommended.

### TLS Certificates

Kubernetes uses TLS certificates to secure communication. You can generate CA certificates, client certificates, and server certificates for secure communication within the cluster.

For detailed steps on generating and managing certificates, refer to the original script.

### Certificate API

You can create and manage certificate signing requests (CSR) to authenticate new users and distribute certificates.

For detailed steps on working with CSR, refer to the original script.

### Kubeconfig File

The kubeconfig file contains information about clusters, users, and contexts. It's used to configure access to Kubernetes clusters. The default kubeconfig file is located at `$HOME/.kube/config`.

To switch between configurations, you can use `kubectl config use-context`.

Remember to secure your TLS certificates and kubeconfig files to ensure the security of your Kubernetes cluster.

## Conclusion

This README provides an overview of various Kubernetes commands and concepts, helping you navigate and manage your Kubernetes clusters effectively.
