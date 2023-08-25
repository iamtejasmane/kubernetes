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

## API Groups

All resources are grouped into two categories: core and named.

Named API Groups -> Resources -> Verbs

To get API groups:

```bash
curl http://localhost:6443 -k
```

To extract group names:

```bash
curl http://localhost:6443 -k | grep "name"
```

To create a proxy server to access the kube-api server using certificates:

```bash
kubectl proxy
```

Use the port of the proxy server to access the API:

```bash
curl http://localhost:<proxy-server-port> -k
```

## Authorization

Authorization modes include Node, ABAC, RBAC, Webhook, AlwaysAllow, and AlwaysDeny.

Modes are set in the kube-api server:

```bash
--authorization-mode=Node,RBAC,Webhook
```

Inspect the environment and identify the authorization modes configured on the cluster:

```bash
kubectl describe pod kube-apiserver-controlplane -n kube-system
```

And check the authorization mode:

```bash
--authorization-mode
```

To create roles and role bindings:

1. Create a role using a definition file:

```bash
kubectl create -f role-definition-file.yaml
```

Or using the command:

```bash
kubectl create role <role-name> --namespace=<namespace-name> --verb=list,create,delete --resource=pods
```

2. Link users to the role by creating a role binding definition file:

```bash
kubectl create -f devuser-developer-binding.yaml
```

Or using the command:

```bash
kubectl create rolebinding <role-binding-name> --namespace=<namespace-name> --role=<role-name> --user=<user-name>
```

Use the namespace in metadata to set it as default.

To check authorization of resources:

```bash
kubectl auth can-i <verbs> <resources>
```

For example:

```bash
kubectl auth can-i create deployments
kubectl auth can-i delete nodes
```

As an admin, you can also check other users' permissions:

```bash
kubectl auth can-i create deployment --as dev-user
kubectl auth can-i create pod --as john --namespace prod
```

## Security Context

Apply security context at the pod and container level:

```yaml
# Pod level
securityContext:
  runAsUser: 1000

# Container level
securityContext:
  runAsUser: 1000
  capabilities:
    add: ["MAC_ADMIN"]
```

Use the `kubectl exec` command to execute commands within a pod:

```bash
kubectl exec <pod-name> -- <command>
```

# Network Policies

Network policies control ingress and egress traffic within the cluster.

Key solutions supporting network policies include Kube-router, Calico, Romana, and Weave-net.

To use network policies:

1. Apply labels to pods:

```bash
kubectl label pods <pod-name> name=payroll
```

2. Create network policies:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-payroll
spec:
  podSelector:
    matchLabels:
      name: payroll
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              name: hr
```

Think from the perspective of the pod to understand network policies.

# Storage

## Docker storage

To manage storage, you can use Docker volumes, bind mounting, and more.

To create a Docker volume:

```bash
docker volume create volume_name
```

this will create a volume in `/var/lib/docker/volumes/volume_name`

To mount a volume to a Docker container:
This is also called This is called **Volume Mount** - Type 1

```bash
docker run -v volume_name:/var/lib/mysql mysql
docker run --mount type=bind,source=/data/mysql,target=/var/lib/mysql mysql
```

here we are mounting the container's internal data volume to our persistent volume. `/var/lib/mysql` container's default volume where it writes the data.

**Layered Structure will be:**

- Top: Read Write - Container
- Mid: Persistent Volumes
- Base: Read Only - Image Layer

To mount diffrerent folder than default `/var/lib/docker` then use the full path to the folder. This is called **Bind Mounting** - Type 2

```bash
docker run -v /data/mysql:/var/lib/mysql mysql
```

New and Recommended way to mount volume:

```bash
docker run --mount type=bind,source=/data/mysql,targe=/var/lib/mysql mysql
```

- _source_ = location on the host
- _target_ = location on the container

## Storage Drivers

Storage drivers help manage storage on images and containers.

Volumes are not handled by storage drivers, volumes are managed by volume plugins like Local, Azure File Storage, Convoy, gce-docker, rexray/ebs etc.

```bash
docker run -it --name mysql --volume-driver rexray/ebs --mount src=ebs-vol,target=/var/lib/mysql mysql
```

## Container Storage Interface

The Container Storage Interface (CSI) supports multiple storage solutions. It's recommended for dynamic provisioning.

# Persistent Volumes and Claims

## Persistent Volumes (PV)

Persistent Volumes (PV) are administrator-created resources.

To configure the volume to existing pod there are 2 ways-

1. Get its yaml file and add `spec.volumes` and `spec.containers.volumeMounts` in that file.

   ```bash
   kubectl get po webapp -o yaml > webapp.yaml
   ```

2. Create a new yaml with the same image and add above properties.
   ```bash
    --dry-run=client -o yaml
   ```
   With the PV - _Static Provisioning_

### Persistent Volume Claim (PVC)

User creates a PVC defining a definition file, where Administrator creates a PV.

- When pvc gets deleted pv is remained.
- To delete pv along with the pvc set

  ```yaml
  persistentVolumeReclaimPolicy: Delete
  ```

Once you create a PVC use it in a POD definition file by specifying the PVC Claim name under `persistentVolumeClaim` section in the volumes section.

The same is true for **ReplicaSets** or **Deployments**. Add this to the pod template section of a Deployment on ReplicaSet. After deleting a PVC of Retain policy the status of the PV becomes **Released**

# Storage Classes

- Used for the dynamic provisioning of the storage.
- If there is no provisioner, its not a dynamic.

Use Storage Classes for dynamic provisioning:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: sc-name
provisioner: example.com/aws-ebs
```

Create Persistent Volume Claims (PVCs):

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 8Gi
  storageClassName: sc-name
```

Use PVCs in Pod definitions:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  volumes:
    - name: myvolume
      persistentVolumeClaim:
        claimName: myclaim
  containers:
    - name: mycontainer
      image: busybox
      volumeMounts:
        - mountPath: /data
          name: myvolume
```

Remember, storage class, behind the scene still creates a pv but automatically.

### Volume Bindig Mode

`volumeBindingMode` - this feild controls when volume binding and dyncamic provisioning should occur.

To run a command on a container running in the pod

```bash
kubectl exec <pod-name> -- <command>
kubectl exec webapp -- cat /log/app.log
```

In case of multiple containers

```bash
kubectl exec my-pod cotainer1 -- ls
```

# Networking

- Create new network namespaces on a Linux host:

  ```bash
  ip netns add namespace-name
  ```

- View network resources on the host:

  ```bash
  ip link
  ```

- Add a container to a specific namespace:

  ```bash
  ip link set <cid> netns <namespace>
  ```

- Identify network interface configured for cluster connectivity:

  ```bash
  ip a | grep -B2 <IP>
  ```

- Identify the interface/bridge created by a container runtime:

  ```bash
  ip link | grep <container-runtime>
  ```

- Check MAC address of a worker node in kubeadm:

  ```bash
  arp node-name
  ```

- Get IP address of the Default Gateway:

  ```bash
  ip route show default
  ```

- Inspect logs of Kubernetes components:

  ```bash
  netstat -nplt
  netstat -nplt | grep kube-scheduler
  ```

  **Note:** 2379 is the port of ETCD to which all control plane components connect to. 2380 is only for etcd peer-to-peer connectivity.

- To check the cni script name in the cni config directory -> by kubelet
  ```bash
  --cni-conf-dir=/etc/cni/net.d
  ```
- To execute the cni script -> by kubelet
  ```bash
  ./net-script.sh add <container> <namespace>
  ```

# CNI in Kubernetes

- Inspect the kubelet service and identify the network plugin:

  ```bash
  ps aux | grep kubelet --network-plugin
  ```

- View configured CNI network plugins:

  ```bash
  ls /opt/cni/bin
  ```

- Check which CNI plugin is configured for use:

  ```bash
  ls /etc/cni/net.d/
  ```

- View all plugin information:

  ```bash
  cat /etc/cni/net.d/<cni-plugin>
  ```

## IP Address Management - IPAM

- Identify the name of the bridge network/interface created by Weave:

  ```bash
  ip link
  ```

- View POD IP address range configured by Weave:

  ```bash
  ip add
  ```

- Check the default gateway configured on the POD:

  ```bash
  ip route
  ```

- Get IP address of Weave:

  ```bash
  ip add show weave
  ```

## Service Networking

Set kube-proxy proxy mode:

```bash
kube-proxy --proxy-mode [userspace | iptables | ipvs]
```

See the service IP range:

```bash
kube-api-server --service-cluster-ip-range ipNet
```

See all rules in iptables:

```bash
iptables -L -t nat
iptables -L -t nat | grep db-service
```

Inspect kube-proxy log:

```bash
cat /var/log/kube-proxy.log
```

## Conclusion

This README provides an overview of various Kubernetes commands and concepts, helping you navigate and manage your Kubernetes clusters effectively.
