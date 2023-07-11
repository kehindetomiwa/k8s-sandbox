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