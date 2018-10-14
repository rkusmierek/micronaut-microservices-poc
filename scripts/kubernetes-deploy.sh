BASE=`dirname $0`

#required by elasticsearch
#sysctl -w vm.max_map_count=262144

SERVICES=`find ${BASE}/../*/k8s/*service.yml`
for SRV in ${SERVICES} ;
do
    kubectl apply -f ${SRV}
done

DEPLOYMENTS=`find ${BASE}/../infra/k8s/*deployment.yml`
for DEPLOYMENT in ${DEPLOYMENTS} ;
do
    kubectl apply -f ${DEPLOYMENT}
done

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml
kubectl apply -f ../infra/k8s/ingress.yml

echo "waiting for infra to start"
sleep 20

${BASE}/kafka-create-cluster.sh

DEPLOYMENTS=`find ${BASE}/../*/k8s/*deployment.yml | grep -v /infra/k8s/`
for DEPLOYMENT in ${DEPLOYMENTS} ;
do
    kubectl apply -f ${DEPLOYMENT}
done

WEB=`kubectl -o json get services web-vue | jq -r .spec.clusterIP`

echo "HTTP endpoint: http://${WEB}"

kubectl describe ingress
