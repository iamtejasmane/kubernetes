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