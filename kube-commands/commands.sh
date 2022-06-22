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


