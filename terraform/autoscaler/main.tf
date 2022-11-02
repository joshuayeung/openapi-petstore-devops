data "terraform_remote_state" "eks" {
  backend = "remote"

  config = {
    organization = "joshuayeungzuhlke"
    workspaces = {
      name = "openapi-petstore-devops"
    }
  }
}

module "eks-cluster-autoscaler" {
  source  = "lablabs/eks-cluster-autoscaler/aws"
  version = "2.0.0"

  enabled           = true
  argo_enabled      = false
  argo_helm_enabled = false

  # insert the 3 required variables here
  cluster_name                     = data.terraform_remote_state.eks.outputs.cluster_name
  cluster_identity_oidc_issuer     = data.terraform_remote_state.eks.outputs.cluster_identity_oidc_issuer
  cluster_identity_oidc_issuer_arn = data.terraform_remote_state.eks.outputs.cluster_identity_oidc_issuer_arn
}
