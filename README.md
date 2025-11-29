# MarkLangan_C22470414_FYP
# commands used to set up, verify and tear down infrastructure
-- Commands for set up
az login
infra/ azz loterraform init
terraform plan
terraform apply
az aks update --resource-group {secrets} --name {secrets} --attach-acr {secrets}
 az aks get-credentials --resource-group {secret} --name {secret} --overwrite-existing
 kubectl get nodes

app/   docker build -t fypcicdregistrymarkl.azurecr.io/fyp-app:latest .
az acr login --name fypcicdregistrymarkl
app/  docker push fypcicdregistrymarkl.azurecr.io/fyp-app:latest
k8s/  kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl get pods
kubectl get svc
-- new window
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
.\run.cmd

-- after successful workflow to verify everyhing
az aks get-credentials --resource-group rg-fyp-cicd-fr --name aks-fyp-fr --overwrite-existing
kubectl get nodes
kubectl get deployments
kubectl get pods
kubectl get svc
check http://4.251.137.32/health
--check tags to verify came from recent workflow
    az acr repository list -n fypcicdregistrymarkl -o table
    az acr repository show-tags -n fypcicdregistrymarkl --repository fyp-app -o table (shows latest commit hash)


-- to delete infrastructure for cost-savings when not in use
az group delete -n rg-fyp-cicd-fr --yes --no-wait
az group delete -n MC_rg-fyp-cicd-fr_aks-fyp-fr_francecentral --yes --no-wait
-- and then after 2 - 3 minutes:
az group list -o table
az aks list -o table
az acr list -o table
az vm list -o table
az resource list -o table
verify no output or in status says deleting