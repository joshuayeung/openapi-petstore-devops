data "terraform_remote_state" "eks" {
  backend = "remote"

  config = {
    organization = "joshuayeungzuhlke"
    workspaces = {
      name = "openapi-petstore-devops"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        local.cluster_name
      ]
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
  cluster_name                     = local.cluster_name
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
}
