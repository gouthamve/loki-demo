```
k3d  create --publish 8082:30080@k3d-k3s-default-worker-0 --publish 3000:30081@k3d-k3s-default-worker-0 --workers 2
export KUBECONFIG="$(k3d get-kubeconfig --name='k3s-default')"
kubectl create -f tiller-rbac.yaml
helm init --service-account tiller
helm repo add loki https://grafana.github.io/loki/charts
helm repo update
helm upgrade --install loki loki/loki-stack
ks apply default
kc create -f k8s-yamls/
```
