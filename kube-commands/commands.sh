# *** Core Concepts ***

# to get all the nodes persent in the cluster
kubectl get nodes

# kubernetes version
kubectl version

# to get flavor and version of OS on which
# the kubernetes nodes are running; all the info of the nodes
kubectl get nodes -o wide

# get all the pods
kubectl get pods

# get a specific pod
kubectl get pods <pod>

# create new pod with an image
kubectl run nginx --image=nginx

# all info
kubectl describe pod <pod>-<ID>
# e.g kubectl describe pod newpods-s8q82

# to check the image used to create new pods
kubectl describe pod <podWihtID> | grep -i image

"ImagePullBackOff error: When image does not exist on the docker hub"

# delete pod
kubectl delete pod <pod>

# to see all the keys stored in etcd on kubeadm
kubectl exec etcd-master -n kube-system etcdctl get --prefix -keys-only

# apply or create pod from yaml file
kubectl apply -f <file>

"to try out something before creating it use: --dry-run-client"

# to edit the pod configuration 
kubectl edit pod <pod>

# * Replication Controller or ReplicaSet *

# to create replicacontroller or replicaset from definition file
kubectl create -f <definition-file-yml>

# get replicaset
kubectl get replicaset

# to see the version for the replicaset 
kubectl explain replicaset | grep VERSION

# get replicacontroller
kubectl get replicacontroller

# to replace or update the existing definition file
kubectl replace -f <definition-file-yaml>
 
# to scale replica using command line without modifying the file
kubectl scale --replicas={count} <definition-file>
kubectl scale replicaset <replicaset-name> --replicas={count}

# delete replica set and also delete all underlaying PODs
kubectl delete replicaset <replicaset-name>

# describe replicaset; all information
kubectl describe replicaset <replicaset-name>

# to edit existing configuration of the replicaset 
# and open running configuration file to edit
kubectl edit replicaset <replicaset-name>

# to get info of all the cerated objects created in the cluster
kubectl get all

# * Deployments *

# to get deployments
kubectl get deployments

# to describe the deployments
kubectl descibe deployment <deployment-name>

# to check the status of the deployment rollouts
kubectl rollout status deployment/<deployment-name>
# e.g
kubectl rollout status deployment/myapp-deployment

# to get history of the rollout deployments
kubectl rollout history deployment/<deployment-name>

# change the image of the deployment using CLI; does not modify the definition file.
# e.g.
kubectl set image deployment/<deployment-name> \nginx=nginx:1.9.1

"Two types of deployment strategies: 1. Recreate - all at once; downtime"
"2. Rolling Update (default): one by one deployment"

# to undo the changes in the newly created replicaset
# and bring back the old replicaset
kubectl rollout undo deployment/myapp-deployment

# record option instrcuts kubernetes to record the cause of the changes
kubectl create -f <definition-file> --record

# * Service *

# to get service
kubectl get service "or" kubectl get svc

# to get a url from the minikube service 
minikube service <service-name> --url

# descibe service
kubectl describe service <service-name>

# nginx with dry run - does not create it
kubectl run nginx --image=nginx --dry-run=client -o yaml

# create deployment without yaml
kubectl create deployment --image=nginx nginx

# deployment dry run
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml

# create deployment from CLI and save it to the file
kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml

# create a service named redis-service of type ClusterIP to expose podredis on port 6379
kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml
"This will automatically use the Pod's labels as selectors"

# Or
kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml
"This will not use the pods labels as selectors; NOT RECOMMENDED"

# create service named nginx of type NodePort to expose pod nginx's port 80 on port 30080 on the nodes
kubectl expose pod nginx --type=NodePort --port=80 --name=nginx-service --dry-run=client -o yaml
"This will automatically use the pod's labels as selectors, but you cannot specify the node port. You have to generate a definition file and then add the node port in manually before creating the service with the pod"

# Create a new pod called custom-nginx using the nginx image and expose it on container port 8080
kubectl run custom-nginx --image=nginx --port=8080

# * Namespace *

# create a namespace with yaml def file
kubectl create -f namespace.yaml

# create a namespace with CLI
kubectl create namespace <name>

# to set a specific namespace as a default one
kubectl config set-context $(kubectl config current-context) --namespace=<namespace-name>

# get pods in specific namespace
kubectl get pods --namespace=<namespace-name>

# to get all the pods in all the namespaces
kubectl get pods --all-namespaces

"to define resources for the namespaces use Resource Quota"

# create pod in another namespace 
kubectl run redis --image=redis -n finance

# get pods in all namespaces
kubectl get pods --all-namespaces

# create a service to expose a deployment
kubectl expose deployment nginx --port 80

# to change the image of the deployment 
kubectl set image deployment nginx nginx=nginx:1.18

# to edit object from using definition file
kubectl replace -f <yaml-file>

# in case of delete and rerun complete object
kubectl replace --force -f nginx.yaml

# to delete object described in the definition file
kubectl delete -f <yaml-file>

# create pod with labels (imperative)
kubectl run --image=redis redis --labels tier=db


# *** Scheduling ***

# ** LABELS AND SELECTORS **

# to filter pod with labels
kubectl get pods --selector app=App1

"annotations in the metadata section used to define other information than labels. ie. buildvesion, email, phone etc."

# to get all the objects in a prod environment
kubectl get all --selector env=prod

# to get a pod with multiple labels
kubectl get all --selector env=pod,bu=finance,tier=frontend

# ** TAINT & TOLERATION **

# tains are added to node
# to taint a node
kubectl taint nodes node-name key=value:taint-effect

"taint-effect describes what happens to POD's that do not tolerate this taint"
# There taint effects 1. NoSchedule 2. PreferNoSchedule 3. NoExecute
kubectl taint nodes node1 app=blue:NoSchedule

# tolerations are added to pod
# In pod definition file inside spec add toleration

"

spec.tolerations:
- key: "app"
  operator: "Equal"
  value: "blue"
  effect: "NoSchedule"
"
# to check tains applied on the node
kubectl describe node node-name | grep Taint

# remove tains from a node
kubectl edit node node-name "and remove the taints section"


# tains and tolerations does not tell a pod to go to a particular node
# instead it tells a node to only accept a pod with certain toleration

# if you requirement is to restrict a pod with certain node then this
# can be achieved with the concept Node Affinity

# Schedular taints the Master node so that its not schedule any nodes on it


# ** Node Selector **
# use only on single selection. Not for complex filtering

# to label a node
kubectl label nodes node-name label-key=label-value
kubectl label nodes node-1 size=Large

"use nodeSelector in the Pod definition file and define the label there"

# ** Node Affinity **
# used for complex and advance expression

"
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
    	nodeSelectorTerms:
	- matchExpressions:
	  - key: size
	    operator: In
	    values:
	    - Large
	    - Medium
"

"operator: Exists" - just to check the size 
# operations are : In, NotIn etc.

# to get pod definition in yaml format
kubectl get pod webapp -o yaml > my-new-pod.yaml

kubectl edit deployment my-deployment
"Since the pod template is a child of the deployment specification,  with every change in the deployment will automatically delete and create a new pod with the new changes"

# The status OOMKilled indicates that it is failing because the pod ran out of memory. Identify the memory limit set on the POD


# ** DAEMON SET **

# to get daemon sets
kubectl get daemonsets

# to describe daemonsets
kubectl describe daemonset daemonset-name

# to get all daemonsets in all the namespaces
kubectl get daemonsets --all-namespaces

# to get events in the current namespace
kubectl get events

# to view the logs of the object
kubectl logs sheduler-object -name-space=namespace-name

# run pod with command
kubectl run --image=busybox busybox --command sleep 1000 -o yaml > busybox.yaml

# create a config map from file
kubectl create -n kube-system configmap my-scheduler-config --from-file=/root/my-scheduler-config.yaml

# *** Monitoring - Matrix-Server ***

# to start matrix server on minikube
minikube addons enable mertrics-server

# for other environment deploy the matrics-server cloning it from the git
git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git
cd <dir>
kubectl create -f .

# to see performance and memory consumption by nodes
kubectl top node

# performance matrics for pod
kubectl top pod

# ** Logs **

# to get logs
kubectl logs -f <log-pod-name> <container-name>  # -f show logs on the screen
kubectl logs -f event-simulator-pod event-simulator

#  *** ROLLOUT & VERSIONING ***

# to check status of the rollout
kubectl rollout status deployment/<deployment-name>

# to see the history of the rollouts
kubectl rollout history deployment/<deployment-name>

# to undo a change 
kubectl rollout undo deployment/<deployment-name>

# ** Commands & Arguments **
'CMD["5"] => args: ["5"]' # in pod definition file

'ENTRTYPOINT["sleep"] => command: ["sleep"]' # in pod definition file

# ** Environment Variables **

# Plain key value
"
env:
	- name: NAME_OF_ENV
	  value: VALUE_OF_ENV 
"
# config map
"
env:
        - name: NAME_OF_ENV
          valueFrom: 
	  	configMapKeyRef: VALUE_OF_ENV 
"
# secret key
"
env:
        - name: NAME_OF_ENV
          valueFrom: 
	  	secretKeyRef: VALUE_OF_ENV 
"

# Config Map
kubectl create configmap <config-name> --form-literal=<key>=<value>

kubectl craete configmap app-config --form-literal=APP_COLOR=blue

# to get config map
kubectl get configmap

# to describe config map
kubectl descibe configmap

# env
"
envForm:
	- configMapRef:
		name: app-config
"
# single env
"
env:
	- name: APP_COLOR
	  valueFrom:
	  	configMapKeyRef:
			name: app-config
			key: APP_COLOR
"

# config from volumes
"
volumes:
- name: app-config-volume
  configMap:
	name: app-config
"

# ** secrets **
# imperative CLI
kubectl create secret generic <secret-name> 
--from-literal=<key>=<value> \
--from-literal=<key>=<value> 

kubectl create secret generic app-secret --from-literal=DB_Host=mysql

# imperative from file
kubectl create secret generic <secret-name> --from-file=<path-to-file>

# to convert the plaintext into base64 | encode
echo -n 'text' | base64
echo -n 'password' | base64

# to get secret 
kubectl get secret 

# to see values
kubectl get secret <secret-name> -o yaml

# to convert base64 into the plaintext
echo -n 'cGFzc3dvcmQ=' | base64 --decode

# env
"
envForm:
	- secretRef:
		name: app-secret
"

# *** Cluster Maintainance *** 

# to move all the pods from a specific node to other nodes during maintainace

# empty the node
kubectl drain <node-name>
kubectl drain node-1

# --ignore-daemonsets - to ignore the daemonset
# it also makes a node unshedulable util you remove the restiction

# drain command will not work if the Pods are not managed by ReplicationController, ReplicaSet, Job, DaemonSet or StatefulSet; 
# use --force ; in such case we'll lost the pods forever


# to make a node unshedulable without terminating or moving its existing pod to another node
kubectl cordon node-name

# to make node available again to schedule the pods 
kubectl uncordon node-name

# ** Cluster Upgrade **

# to check the version there are two ways
# 1. kubectl version
# 2. kubectl get nodes && check its VERSION

# upgrade master

# to check upgrades on kubeadm
kubeadm upgrade plan

# to upgrade kubeadm tool
sudo apt upgrade -y kubeadm=1.12.0-00
kubeadm upgrade apply v1.12.0

# upgrading kubeadm does not shows the result on get nodes command

# to get the list of tokens to create a cluster
kubadm token list 

# Tip: status ScheduingDisabled = due to Uncordened node

# to upgrade kubelet
sudo apt upgrade -y kubelet=1.12.0-00 
systemctl restart kubelet # once the package is updated restart the kubelet service
# upgrading the kubelet shows the result on get nodes command

# to upgrade node config
kubeadm upgrade node config --kubelet-version v1.12.0
systemctl restart kubelet

# all the "kubectl" commands run on the controlplane component only

# STEPS to upgrade master node
# 1. update package list of the node
     apt update
# 2. install kubeadm with desired version
     apt install kubeadm=1.20.0-00
# 3. upgrade kubernetes controlplane
     kubeadm upgrade apply v1.20.0
# 4. update the kubelet version
     apt install kubelet=1.20.0-00
# 5. restart the kubelet
     systemctl restart kubelet


# STEPS to upgrade worker node
# 1. drain node and make it unschedulable
     kubectl drain <node-name> # this has to be run on controlplane component; not on the worker node

# 1.2 ssh into the node

# 2. update plackage list 
     apt update
# 3. upgrade kubelet
     apt insatll kubeadm=1.20.0-00
# 4. upgrade new node configuration 
     kubeadm upgrade node
# 5. update the kubelet version
     apt install kubelet=1.20.0-00
# 6. restart kubelet after upgrade
     systemctl restart kubelet
# 6.1 logout / exit

# 7. make node schedulable 
     kubectl uncordon <node-name>  # this has also to be done on the master node

# TIP: How many nodes can host workloads in the cluster -> check taints applied on them if there is no
# taint applied on the nodes both the nodes can host workloads

     
# ** Backup & Restore **

# to get backup of all the resources into a definition file
kubectl get all --all-namespaces -o yaml > all-deploy-services.yaml

# tools to do this -> velero - take a backup of your kubernetes cluster using the kubernetes API

# ** etcd **
# etcd cluster stores information of the state of your cluster 
# to take a snapshot
etcdctl snapshot save snapshot-name
etcdctl snapshot save snapshot.db

# Note:
"Use the etcdctl snapshot save command. You will have to make use of additional flags to connect to the ETCD server.
--endpoints: Optional Flag, points to the address where ETCD is running (127.0.0.1:2379)
--cacert: Mandatory Flag (Absolute Path to the CA certificate file)
--cert: Mandatory Flag (Absolute Path to the Server certificate file)
--key: Mandatory Flag (Absolute Path to the Key file)"

# to check the endpoints
kubectl describe  pods -n kube-system etcd-cluster1-controlplane  | grep advertise-client-urls

# to view the status of the backup
etcdctl snapshot status snapshot-name

"ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /opt/snapshot-pre-boot.db"


# to restore cluster from this snapshot

# 1. stop kubeapi server
     service kube-apiserver stop
# 2. run the restore snapshot command with the path of the snapshot file
     etcdctl snapshot restore snapshot.db --data-dir /var/lib/etcd-from-backup
#    after this new backup dir created at --data-dir=/var/lib/etcd-from-backup
# 3. reload the service daemon
     systemctl daemon-reload
# 4. restart etcd service 
     service etcd restart
# 5. start kubeapi server
     service kube-apiserver start

# To make use of etcdctl for tasks such as back up and restore, make sure that you set the ETCDCTL_API to 3
# etcdctl is a command line client for etcd
# you can do this by exporting etcd 

"on master node"
export ETCDCTL_API=3 


# TIP: what address can we reach the ETCD cluster from the controlplane node?
# -> describe etcd pod and check --listen-client-urls

# ***| Security |***

# ** Authenication **

# to pass basic username & password to kube-apiserver for authentication
# kubeadm = kube-apiserver.yaml | NOT Recommended
--basic-auth-file=user-details.csv # for basic auth
--token-auth-file=user-details.csv # fro static token file


# ** TLS Certificates **

# creates public and private key
ssh-keygen # on the client

# secure your server locking down all access to it except the one with the public key
# it's usually done by adding an wntry with you public key into the server's
cat ~/.ssh/authorized_keys # file

# to secure multiple server you can use same public key to lock them and
# the same private key to access them

# for asymmetric encryption we generate a public and private key pair on the server
# here we use the openssl command on the server

openssl genrsa -o my-secret.key 1024 # private key
openssl genrsa -0 my-secret.key -pubout > mysecret.pem # for public key

# ** TLS In Kubernetes **

# all the servers in the kubernetes uses the server certificates
# all the clien uses the client certificates

# you can have multiple CA's for the kubernetes cluster 
# requires at least one

# * CA certificates *

# 1. generate CA certificates
openssl genrsa -out ca.key 2048

# 2. certification signing request 
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr

# 3. sign certificates 
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt

# * Client certificates *

# admin certificates

# 1. generate certificates
openssl genrsa -out admin.key 2048

# 2. certification signing req
openssl -req -new -key admin.key -subj "/CN=kube-admin/O=system:masters" -out admin.csr # O - group - system:masters - privilages

# 3. sign certificates 
openssl x509 -req -in admin.csr -CA ca.crt -CAKey ca.key -out admin.crt

# all other kube components name is prefixed by system e.g.
# for kube-scheduler
openssl -req -new -key sheduler.key -subj "/CN=system:kube-scheduler" -out scheduler.csr # CN - Comman Name

# FQDN for kube-apiserver
https://kubernetes.default.svc.cluster.local

# kubelet server certificate named as per there node name
openssl -req -new -key node01.key -subj "/CN=kubelet" -out node01.csr # this should be followed for all other nodes
 
# kubelet client certificate
openssl -req -new -key admin.key -subj "/CN=system:node:node01/O=system:nodes" -out admin.csr # O - group - system:nodes - privilages

# * View Certifications *

cat /etc/kubernetes/manifests/kube-apiserver.yaml

# decode a specific certificate
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout

# to inspect it 
# 1. start with the name in subject section
# 2. Alternate names
# 3. check expiry in Not After section
# 4. Issuer of the certificate, this should be the CA who issued this certificate. 

# for troubleshooting check logs

# TIP: sometimes if the core components such as api-server or the etcd server are down, the kubectl command won't function
# In that case you have to go one level down to fetch the logs. List all the containers using the docker ps -a command.
# And view the logs using 'docker logs <container-ID>' command 

# * Certificate API * 

# for a new user

# 1. Create CertificateSigningRequest object
# 2. Review Request by admin
# 3. Approve Req by server
# 4. Share Certs to users

# Steps:
openssl genrsa -out tejas.key 2048
openssl req -new -key tejas.key -subj "/CN=tejas" -out tejas.csr

# admin takes the keys and generate base64 encoded file for the request object
cat tejas.csr | base64 | tr -d "\n"

# create tejas-csr.yaml

# to see all certification signing request 
kubectl get csr

# to view cert details in yaml
kubectl get csr tejas -o yaml

# approve the request 
kubectl certificate approve tejas

# to deny the request
kubectl certificate deny agent-jackson

# to delete csr object
kubectl delete csr agent-jackson


# TIP: kube-controller-manager is reponsible for handling the approve and signing operations on the certifications


# * Kubeconfig file *

# to view the kubeconfig file 
kubectl config view 

# by default it uses the path
$HOME/.kube/config

# to pass a specific path
kubectl config view --kubeconfig=my-custom-config-path

# make you custom config file as default config update the default config file

# to change/update the current context
kubectl config use-context prod-user@production

# * API Groups *

# All resources grouped into two categories - 1. core 2. named

# named API Groups -> Resouces -> Verbs

# to get api groups
curl http://localhost:6443 -k

curl http://localhost:6443 -k | grep "name"

# to create a proxy server to access kubeapi server that uses the certs
kubectl proxy

# use the port of the proxy server
curl http://localhost:<proxy-server-port> -k

# * Authorization *

# authorization modes
# 1. Node 2. ABAC 3. RBAC 4. Webhook
# 4. AlwaysAllow 5. AlwaysDeny - Always allow/deny req without having authorization checks

# modes are set to kubeapi-server
--authorization-mode=Node,RBAC,Webhook # default - ALwaysAllow 

# Inspect the environment and identify the authorization modes configured on the cluster
kubectl describe pod kube-apiserver-controlplane -n kube-system
# and check
--authorization-mode


# Steps to create roles: 

# 1. create a roles using definition files
kubectl create -f role-definition-file.yaml

# or

kubectl create role <role-name> --namespace=<namespace-name> --verb=list,create,delete --resource=pods

# 2. link user to the role by creating role binding definition file
kubectl create -f devuser-developer-binding.yaml

# or 

kubeclt create rolebinding <role-binding-name> --namespace=<namespace-name> --role=<role-name> --user=<user-name>

# use namespace in metadata to set it default 

# to get roles
kubectl get roles

# to get rolebindings
kubectl get rolebindings

# to describe 
# same as other

# to check authorization of some resources 
kubectl auth can-i <verbs> <resources>

kubectl auth can-i create deployments
kubectl auth can-i delete nodes

# as admin you can check other users permission
kubectl auth can-i create deployment --as dev-user

kubectl auth can-i create pod --as john --namespace prod

# you we restrict access to use resources within same namespace using resourceNames in the role definition file
resourceNames: ["pod1","pod2"]

# pods, services, deployments, roles. rolebindings are namespace scoped resources
# Roles and Rolebindings are namespaces scoped

# to check all the namespace scoped resources
kubectl api-resources --namespaced=true

# * Cluster Roles and Cluster Rolebindings *

# nodes, PV, clusterroles, clusterrolebindigs, namespaces, csr are cluster scoped resource they can not be associated with any perticular namespace

# to check all the non namespaced resources
kubectl api-resources --namespaced=false

# What user/groups are the cluster-admin role bound to? -> check clusterrolebindings

# ** Service Accounts **

# to create service account
kubectl create serviceaccount sa-name # other ops : get descibe

# describe a secret token from the service account 
kubectl describe secret secret-name-token

# to check secret inside a pod
kubectl exec -it pod-name ls /var/run/secrets/kubernetes.io/serviceaccount

# to add service acc in pod def file
serviceAccountName: sa-name

# to disable auto mount of a pod 
automountServiceAccountToken: false



#
#
#
#
#
#





# * Security Context *

# in pod def file 
# to apply security on pod leve
securityContext:  # -> spec 
	runAsUser: 1000

# to apply security on container level -> spec.containers
securityContext:
	runAsUser: 1000
	capabilities:  # only for container level not applicable to pod level
		add: ["MAC_ADMIN"] 

# TIP: If you need to process something 'within' a pod 
kubectl exec pod-name -- <CMD>


# ** Network Policies **

# network policies are another object in kubernetes just like pod, replicasets or services
# we can link a network policy to one or more pods
# we can control ingress and egress trafic using network policies 
# but it can only control the trafic on which network policy is applied on

# Solutions that support network policies
# 1. Kube-router 2. Calico 3. Romana 4. Weave-net

# Solutions that do not support networking policies 
# 1. Flannel

# in the network policy if we only have namespaceSelector and not have podSelector then it considers all pods within that namespace

# check out network-policy.yaml in cka folder

# to get pod with a specific label
kubectl get po --show-labels | grep name=payroll

# TIP: think on the solution from the perspective of the pod on which the network policy is applied to

# *** Storage ***

# ** Storage in docker **

# create docker volume
docker volume create volume_name
# this create a volume in /var/lib/docker/volumes/volume_name

# to mount a volume to docker container 
# This is called 'Volume' Mount - type 1
docker run -v volume_name:/var/lib/mysql mysql
# here we are mounting the container's internal data volume to our persistent volume. /var/lib/mysql container's default volume where it writes the data

# Layed structure will be:
# Top:  Read Write - Container 
# Mid:  Persistent Volumes
# Base: Read Only - Image Layer


# to mount diffrerent folder than default /var/lib/docker then use the full path to the folder
# This is called 'Bind' Mounting - type 2 
docker run -v /data/mysql:/var/lib/mysql mysql

# New and Recommended way to mount volume 
docker run --mount type=bind,source=/data/mysql,targe=/var/lib/mysql mysql

# source - location on the host; target = location on the container

# * storage drivers *

# storage drivers help manage storage on images and containers

# volumes are not handled by storage drivers, volumes are managed by volume plugins like Local, Azure File Storage, Convoy, gce-docker, rexray/ebs
docker run -it --name mysql --volume-driver rexray/ebs --mount src=ebs-vol,target=/var/lib/mysql mysql


# * Container Storage Interface *

# the container storage interface was developed to support multiple storage solutions.

# * Persistent Volume *

# create a pv with definition file - define - access mode, capacity, hostpath

# administrator creates a pv

# to configure the volume to existing pod
# two ways 

# 1. get its yaml and add spec.volumes and spec.containers.volumeMounts there
kubectl get po webapp -o yaml > webapp.yaml

# 2. create a new yaml with the same image and add above properties
 --dry-run=client -o yaml

# with the PV -  static provisioning

# * Persistent Volume Claim *

# user creates a pvc defining a definition file

# when pvc gets deleted pv is remained 
# to delete pv along with the pvc set
persistentVolumeReclaimPolicy: Delete


# Once you create a PVC use it in a POD definition file by specifying the PVC Claim name under persistentVolumeClaim section in the volumes section

# The same is true for ReplicaSets or Deployments. Add this to the pod template section of a Deployment on ReplicaSet

# After deleting a PVC of Retain policy the status of the PV becomes 'Released'

# * Storage Classes *

# used for the dynamic provisioning of the storage

# if there is no provisioner; its not a dynamic

# create a storage class definition file 
# and add 
storageClassName: sc-name # in spec section of pvc definition file

# storage class, behind the scene still creates a pv but automatically

# Volume Bindig Mode
volumeBindingMode # this feild controls when volume binding and dyncamic provisioning should occur.

# to run a command on a container running in the pod
kubectl exec <pod-name> -- <command>
kubectl exec webapp -- cat /log/app.log

kubectl exec my-pod cotainer1 -- ls # in case of multiple container

# ** Networking **

# to create an new network namespaces on linux host
ip netns add namespace-name
ip netns add blue

# to see the network resources on host
ip link

# to see the network resources on the namespace
ip netns exec namespace-name ip link
# or
ip -n namespace-name link

# to add a container into a specific namespace
bridge add <cid> <namespace>


# to check MAC add of worker node in kubeadm
apr node-name

# to get IP address of the Default Gateway
ip route show default

# to check process or ports of the kubernetes components
netstat -nplt
netstat -nplt | grep kube-scheduler

# 2379 is the port of ETCD to which all control plane components connect to. 2380 is only for etcd peer-to-peer connectivity.

# to check the cni script name in the cni config directory -> done by kubelet
--cni-conf-dir=/etc/cni/net.d

# to find cni script -> done by kubelet
--cni-bin-dir=/etc/cni/bin

# to execute the cni script -> done by kubelet
./net-script.sh add <container> <namespace>


# * CNI in kubernetes *

# to see the cni network plugins
ps -aux | grep kubelet

# cni bin directory has all the supported CNI plugins as executable
ls /opt/cni/bin

# to see which of the above plugin use, kubelet looks into 
ls /etc/cni/net.d

# to see all the plugin information
cat /etc/cni/net.d/<cni-plugin>


# * weave work cni *

# to inspect the kubelet service and indentify network plugin
ps aux | grep kubelet --network-plugin

# path to all configured cni 
ls /opt/cni/bin

# to check which cni plugin configured to be used by k8s cluster
ls /etc/cni/net.d/

# to see binary executable file run by kubelet after container creation
cat /etc/cni/net.d/10.flannel.conflist

# to know host system's ip add & the network range of the nodes
ip a | grep eth0

# to check network range of the ip configured for PODs on the cluster
kubectl logs <weave-pod-name> weave -n <namespace-name>

# to check ip range configured for the service within a cluster
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep cluster-ip-range

# to get type of kube-proxy pod
kubectl logs <kube-proxy-pod-name> -n kube-system

# to inspect log of the weave cni pod
kubectl logs -n kube-system weave-net-6mckb -c weave

# to install weave cni plugin with a specific range
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=10.50.0.0/16"

# * IP addr management - IPAM *

# to identify the name of the bridge network/interface created by weave on each node
ip link

# to POD IP address range configured by weave
ip add
# or
kubectl logs <weave-pod-name> weave -n kube-system

# to check defaull gateway configured on the POD
ip route # check gateway for cni soln

# to get ip address of weave 
ip add show weave

# * Service Networking *

# to set proxy-mode
kube-proxy --proxy-mode [userspace | iptablkes | ipvs] 
# default iptablkes
# or 
kubectl logs <kube-proxy-pod-name> -n kube-system

# to see the service ip range
kube-api-server --service-cluster-ip-range ipNet
# default 10.0.0.0/24
# or 
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep cluster-ip-range


# to see all the rules in iptable
intables -L -t nat
intables -L -t nat | grep db-service

# to see kube-proxy log
cat /var/log/kube-proxy.log


# * DNS in kubernetes *

#  Kube-DNS table structure:
 _________________________________________________________________
|  Hostname   | Namespaces | Type |     Root      | IP Address    |
|_____________|____________|______|_______________|_______________|
| web-service |      apps  |  svc | cluster.local | 10.107.37.188 |
| 10-244-2-5  |      apps  |  pod | cluster.local | 10.244.2.5    |
|_____________|____________|______|_______________|_______________|
# dns servcer name - CoreDNS

# to see coredns core file 
cat /etc/coredns/Corefile

# to find the coredns file in the cluster if its not at default location mentioned above
kubectl -n kube-system describe deployments.apps coredns | grep -A2 Args | grep Corefile

# TIP: while troubleshooting, check namespaces or FQDN to the env variables values

# From the a pod1 nslookup the mysql service and redirect the output to a file /root/CKA/nslookup.out
kubectl exec -it pod1 -- nslookup mysql.payroll > /root/CKA/nslookup.out
# here mysql.payroll is a service name



# this corefile are passed as configmap object
kubectl get configmap -n kube-system

# the ip address of the core-dns service is passed to the /etc/resolv.conf -> nameserver & search field
# all these are done by the kubelet
cat /var/lib/kubelet/config.yaml # see the clusterDNS is mentioned here

# get check FQDN for a service 
host <service-name>

# to check config file for the Coredn service
"describe coredns pod"

# * Ingress Networking - 1 *

# how ingress works
# 1. Deploy - you deploy a solution such as nginx, traefik, haproxy, Istio as a 'Ingress Controller'

# 2. Cofigure - Ingress Resources

# Ingress controller does not come as default


# to create ingress resource - imperative
kubectl create ingress <ingress-name> --rule="host/path=service:port"

kubectl create ingress ingress-test --rule="wear.my-online-store.com/wear*=wear-service:80"

# to see the logs for the failed pods
kubectl logs <pod-name> -f 

# to see the logs of the previous pod
kubectl logs <pod-name> -f --previous


# *** Troubleshooting ***

# ** Toubleshooting Application **

# to see the previous logs of the pod
kubectl logs pod-name -f --previous

# ** Troubleshooting Worker Node

# when a worker node stops communicating with the master, may be due to a crash, these status are set to Unknown



# to describe a node and check status
kubectl describe node <node-name>

# to check cpu and process
top

# to check disks
df -h

# to check status of the kubelet 
service kubelet status
# if kubelet is stopped then start kubelet
service kubelet start

# check kubelet logs 
sudo journalctl -u kubelet

# to check kubelet certificates
openssl x509 -in /var/lib/kubelet/worker-1.crt -text

# kubelet files directory
/var/lib/kubelet/config.yaml 

# to check the master server and its port defined in the worker node config
/etc/kubernetes/kubelet.conf



