# MarkLangan_C22470414_FYP
Commands for set up
az login
terraform init
terraform plan
terraform apply
az aks update --resource-group {secrets} --name {secrets} --attach-acr {secrets}
 az aks get-credentials --resource-group {secret} --name {secret} --overwrite-existing
 kubectl get nodes

docker build -t fypcicdregistrymarkl.azurecr.io/fyp-app:latest .
az acr login --name fypcicdregistrymarkl
docker push fypcicdregistrymarkl.azurecr.io/fyp-app:latest
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl get pods
kubectl get svc
-- new window
.\run.cmd