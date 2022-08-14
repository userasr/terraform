#### Prerequisite:
* aws cli configured: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config
* Terraform executable.


#### Steps to Create EKS Cluster:
* Update variables in dev-conf.tfvars file.
* Run the following commands to create the cluster:

  `terraform init`
  
  `terraform apply -var-file dev-conf.tfvars`
  
  
#### Download kubectl(https://kubernetes.io/docs/tasks/tools/):
* Linux: curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl
* Windows: curl -LO https://dl.k8s.io/release/v1.21.0/bin/windows/amd64/kubectl.exe

#### Configure kubectl:
   
   `aws eks --region us-east-1 update-kubeconfig --name <EKS_CLUSTER_NAME>`
   
#### Confirm if cluster is accessible:

  `kubectl get nodes`
  
This should return the list of nodes available in the cluster.

#### Kubernetes-Dashboard Installation:
Run command to deploy all object needed for kubernetes-dashboard:

  `kubectl apply -f kubernetes-dashboard.yaml`
  
This will avail the kubernetes dashboard on port 30000

Now create the following ServiceAccount and ClusterRoleBinding:

  `kubectl create serviceaccount dashboard-admin-sa`
  
  `kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa`
  
To access the dashboard, you will need the auth token. Use the following command to get it:
  `kubectl describe secret $(kubectl get secret | grep dashboard-admin-sa | awk '{print $1}')`
