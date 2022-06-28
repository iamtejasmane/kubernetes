# get all the nodes persent in the cluster
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
# e.g kubectl descibe pod newpods-s8q82

# to check the image used to create new pods
kubectl descibe pod <podWihtID> | grep -i image

"ImagePullBackOff error: When image does not exist on the docker hub"

# delete pod
kubectl delete pod <pod>


# apply or create pod from yaml file
kubectl apply -f <file>

"to try out something before creating it use: --dry-run-client"

# to edit the pod configuration 
kubectl edit pod <pod>

# to create replicacontroller or replicaset from definition file
kubectl create -f <definition-file-yml>

# get replicaset
kubectl get replicaset

# get replicacontroller
kubectl get replicacontroller

# to replace or update the existing definition file
kubectl replace -f <definition-file-yaml>
 
# to scale replica using command line without modifying the file
kubectl scale --replicas={count} <definition-file>
kubectl scale replicaset <replicaset-name> --replicas={count}

# delete replica set and also delete all underlaying PODs
kubectl delete replicaset <replicaset-name>

# descibe replicaset; all information
kubectl describe replicaset <replicaset-name>

# to edit existing configuration of the replicaset 
# and open running configuration file to edit
kubectl edit replicaset <replicaset-name>

# to get info of all the cerated objects created in the cluster
kubectl get all

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

"Tow types of deployment strategies: 1. Recreate - all at once; downtime"
"2. Rolling Update (default): one by one deployment"

# to undo the changes in the newly created replicaset
# and bring back the old replicaset
kubectl rollout undo deployment/myapp-deployment

# record option instrcuts kubernetes to record the cause of the changes
kubectl create -f <definition-file> --record

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
tolerations:
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

"operator: Exists" - just check the size 
# operations are : In, NotIn etc.

# to get pod definition in yaml format
kubectl get pod webapp -o yaml > my-new-pod.yaml

kubectl edit deployment my-deployment
"Since the pod template is a child of the deployment specification,  with every change the deployment will automatically delete and create a new pod with the new changes"

# The status OOMKilled indicates that it is failing because the pod ran out of memory. Identify the memory limit set on the POD.


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

# to start matrix server on minikube
minikube addons enable mertrics-server

# for other environment deploy the matrics server cloning it from the git
git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git
kubectl create -f .

# to see performance and memory consumption by nodes
kubectl top node

# performance matrics for pod
kubectl top pod

# to get logs
kubectl logs -f log-pod-name container-name
kubectl logs -f event-simulator-pod event-simulator






