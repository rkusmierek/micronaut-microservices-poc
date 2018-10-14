gcloud container clusters create micronaut --num-nodes 4 --zone europe-west3-a --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"

# required by nginx-ingress controller
kubectl create clusterrolebinding cluster-admin-binding \
 --clusterrole cluster-admin \
 --user $(gcloud config get-value account)