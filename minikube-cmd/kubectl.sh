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

kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-   #node/controlplane untainted
kubectl taint node node01 spray=mortein:NoSchedule
kubectl describe node node01 | grep -i taint

#inspect log
kubectl -n elastic-stack logs kibana
#to inspect log in a directory, exec to the pode and cat the file
kubectl -n elastic-stack exec -it app -- cat /log/app.lo

#update
kubectl apply -f deployment/aapp
kubectl set image deployment/aapp image=imagef

#check history
kubectl rollout history deployment nginx --revision=1

#record command used to create update
kubectl set image deployment nginx nginx=nginx:1.17 --record

kubectl rollout status deployment/aapp
kubectl rollout history deployment/aapp
kubectl rollout undo deployment/aapp


kubectl create job throw-dice-job --image=kodekloud/throw-dice --dry-run=client -o yaml

kubectl logs <pod-name>

#access k8s using curl command
curl -v -k https://master-node-ip:4554/api/vi/pods -u "user1:password123"
or use token
curl -v -k https://master-node-ip:4554/api/vi/pods --header "Aithorization: Bearer <token>"

kubectl describe pod kube-apiserver-controlplane -n kube-system

#create rolebinding and role

kubectl create role developer --namespace=default --verb=list,create,delete --resource=pods
kubectl create rolebinding dev-user-binding --namespace=default --role=developer --user=dev-user


kubectl auth can-i list nodes --as michelle

kubectl api-resources
kubectl auth can-i list storageclasses --as michelle.

kubectl create clusterrole storage-admin --resources=persistentvolumes,storageclasses --verb=list,create,get,watch
kubectl create clusterrolebinding michelle-storage-admin --user=michelle --clusterrole=storage-admin

kubectl exec -it kube-apiserver-controlplane -n kube-system -- kube-apiserver -h | grep 'enable-admission-plugins'

#list all enabled and disabled plugins 
ps -ef | grep kube-apiserver | grep admission-plugin

kubectl -n webhook-demo create secret tls webhook-server-tls --cert "/root/keys/webhook-server-tls.crt" --key "/root/keys/webhook-server-tls.key"


kubectl describe crd globals.traffic.controller

kubectl scale deployment --replicas=1 frontend-v2







