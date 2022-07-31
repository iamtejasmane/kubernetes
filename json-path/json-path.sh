# to use if - ?()
$[?()]

# to denote each item in the list - @
# to get all numbers greater than 40 
$[?( @ > 40)]

# other operators
@ == 40
@ != 40

@ in [40,43,45]
@ nin [40,43,45]

# query to complex obj
$.car.wheels[?(@.location == "rear-right")].model

$.prices[?(@)].laureates[?(@.id == "914")]

# to get all properties use wild card operator - *
$.*.price
$.car.wheels[*].model
$.*.wheels[*].model

$.prizes[?( @.year == "2014")].laureates[*].firstname


# list with json path
$[0:8]
# start : end

# start : end : step
# skips steps
$[0:8:2]

# to get last item in the list
$[-1]

# ** JSON PATH With kubectl **

# to get output in json format
kubectl get node -o json
kubectl get pod -o json

# to use the json path query with kubectl command
kubectl get pods -o=jsonpath= <query>

kubectl get pods -o=jsonpath= '{.items[0].spec.containers[0].image}' # $ is optional

# to get name of all the nodes
kubectl get nodes -o=jsonpath='{.items[*].metadata.name}'

# to get cpu count
kubectl get nodes -o=jsonpath='{.items[*].status.capacity.cpu}'

# to get multiple output - node-name, cpu
kubectl get nodes -o=jsonpath='{.items[*].status.capacity.cpu}{.items[*].metadata.name}'

# to get multiple output - node-name, cpu
kubectl get nodes -o=jsonpath='{.items[*].status.capacity.cpu}{"\n"}{.items[*].metadata.name}'


# for each in jsonpath
kubectl get nodes -o=jsonpath='{range .items[*]}{.metadata.name} {"\t"} {.status.capacity.cpu}{"\n"}{end}'

# json path with custom-columns
kubectl get nodes -o=custom-columns=NODE:.metadat.name,CPU:.status.capacity.cpu

# to sort the result
kubectl get nodes --sort-by=.metadata.name

kubectl get nodes --sort-by=.status.capacity.cpu




