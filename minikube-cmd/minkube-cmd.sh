minikube start --kubernetes-version=v1.23.3 --driver=podman --profile minipod

minikube start --nodes=2 --kubernetes-version=v1.24.4 --driver=docker --profile doubledocker

minikube start --driver=virtualbox --nodes=3 --disk-size=10g --cpus=2 --memory=4g --kubernetes-version=v1.25.1 --cni=calico --container-runtime=cri-o -p multivbox

minikube start --driver=docker --cpus=6 --memory=8g --kubernetes-version="1.24.4" -p largedock

minikube start --driver=virtualbox -n 3 --container-runtime=containerd --cni=calico -p minibox

minikube start --driver=hyperkit -n 3 --kubernetes-version=v1.25.3 --container-runtime=containerd --cni=calico


minikube addons list
minikube addons enable metrics-server
minikube addons enable dashboard
minikube addons list
minikube dashboard 


#setup users, role, role binding for nameapace

#generate key (user is victoryhouse)
openssl genrsa -out victoryhouse.key 2048
openssl req -new -key victoryhouse.key -out victoryhouse.csr -subj "/CN=victoryhouse/O=learner"

cat bob.csr | base64 | tr -d '\n','%' #save output in signin=request file 

kubectl create -f signing-request.yaml
kubectl get csr
kubectl certificate approve victoryhouse-csr

#Extract the approved certificate from the certificate signing request, decode it with base64 and save it as a certificate file. Then view the certificate in the newly created certificate file:
kubectl get csr victoryhouse-csr -o jsonpath='{.status.certificate}' | base64 -d > victoryhouse.crt

#Configure the kubectl client's configuration manifest with user bob's credentials by assigning his key and certificate: 

 kubectl config set-credentials victoryhouse --client-certificate=victoryhouse.crt --client-key=victoryhouse.key
#Create a new context entry in the kubectl client's configuration manifest for user bob, associated with the lfs158 namespace in the minikube cluster:
 kubectl config set-context victoryhouse-context --cluster=minikube --namespace=lfs158 --user=victoryhouse


