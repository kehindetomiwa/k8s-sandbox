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