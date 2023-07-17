kubectl get pods -A

# access root directory of k8s API without using proxi
# first step, create auth token

export TOKEN=$(kubectl create token default)
kubectl create clusterrole api-access-root --verb=get --non-resource-url=/*

kubectl create clusterrolebinding api-access-root --clusterrole api-access-root --serviceaccount=default:default
# Retrieve the API Server endpoint:
export APISERVER=$(kubectl config view | grep https | cut -f 2- -d ":" | tr -d " ")
echo $APISERVER
kubectl cluster-info
curl $APISERVER --header "Authorization: Bearer $TOKEN" --insecure

kubectl apply -f nginx.yaml
kubectl run firstrun --image=nginx

kubectl run firstrun --image=nginxx --port=88 --dry-run=client -o yaml > secondrun.yaml

kubectl replace --force -f secondrun.yaml # to replace already created pod that failed or want to update
kubectl create deployment mynginx --image=nginx:1.15-alpine

kubectl get deploy,rs,po -l app=mynginx
kubectl scale deploy mynginx --replicas=3
kubectl set image deployment mynginx nginx=nginx:1.16-alpine
kubectl rollout undo deployment mynginx --to-revision=1

kubectl create deployment deploy-hello --image=pbitty/hello-from:latest --port=80 --replicas=3
kubectl expose deployment deploy-hello --type=NodePort

kubectl get deploy,svc,ep -l app=deploy-hello --show-labels

kubectl create configmap my-config --from-literal=key1=value1 --from-literal=key2=value2
kubectl get configmaps my-config -o yaml


kubectl run redis --image=redis123 --dry-run -o yaml

#edit a pod
kubectl get pod <pod-name> -o yaml > pod-definition.yaml
# then edit the file
kubectl edit pod <pod-name>

kubectl create -f customer1-configmap.yaml
kubectl create configmap permission-config --from-file=<path/to/>permission-reset.properties

#config map fromfile
kubectl create configmap green-web-cm --from-file=green/index.html 

#secrets
kubectl create secret generic my-password --from-literal=password=mysqlpassword
kubectl get secret my-password
kubectl describe secret my-password

#data map (password encoded in base 64 and used in manifest file
echo mysqlpassword | base64

# secret from file

# 1. encode password
echo mysqlpassword | base64

# 2. push to a file 
echo -n 'bXlzcWxwYXNzd29yZAo=' > password.txt

# 3 create the secret 
kubectl create secret generic my-file-password --from-file=password.txt

kubectl scale --replicas=6 -f replicaset-definition.yaml

#change parmanetly to a namespace
kubectl config set-context $(kubectl config current-context) --namespace=dev


kubectl run webapp-color --image=nginx --dry-run=client -o yaml > nginx-pod.yaml

kubectl get pod <pod-name> -o yaml 

kubectl create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123

kubectl replace --force -f <yaml-file>

kubectl exec ubuntu-sleeper -- whoami

kubectl create serviceaccount dasboard-sa