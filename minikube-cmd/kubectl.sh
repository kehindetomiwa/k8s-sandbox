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