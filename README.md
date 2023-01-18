# EKS-Kubectl
Run kubectl commands with AWS authentication and a set of AWS keys

# Usage 
```yaml
resource_types:
- name: eks-kubectl
  type: registry-image
  source:
    repository: ghcr.io/doutorfinancas/eks-kubectl
    tag: 1.23

resources:
- name: eks-kubectl
  type: eks-kubectl
  icon: kubernetes
  source:
    aws_access_key_id: YOU_AWS_ACCESS_KEY_HERE
    aws_secret_access_key: YOU_AWS_SECRET_ACCESS_HERE
    eks_cluster_name: my-cluster
    eks_region: eu-central-1
    namespace: my-namespace

jobs:
  - name: kubernetes-deployment
    plan:
      - put: eks-kubectl
        params:
          kubectl: get nodes
      - put: eks-kubectl
        params:
          kubectl: rollout restart deployment/my-deployment
          namespace: my-other-namespace
```

## Why?
Because we needed a simple script to authenticate to AWS and do a simple command for us.
We also needed different kubectl versions from the ones maintained, so, here we are

## Resource definition - Source
| Parameter Name        | Description                                                                |
|-----------------------|----------------------------------------------------------------------------|
| aws_access_key_id     | AWS KEY (mandatory)                                                        |
| aws_secret_access_key | AWS Secret (mandatory)                                                     |
| eks_cluster_name      | EKS cluster name (mandatory)                                               |
| eks_region            | EKS cluster region (mandatory)                                             |
| namespace             | Kubernetes namespace (optional). This will replace the `default` namespace |

## PUT - Params
| Parameter Name | Description                                                                                                                                  |
|----------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| kubectl        | [kubectl command](https://kubernetes.io/docs/reference/kubectl/) you wish to run                                                             |
| namespace      | [kubernetes namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/), overrides source namespace (optional) |

## participating
Want more features? PRs are welcome :)

## Versions
Currently, we have kubectl version 1.23.0 published. Feel free to ask for more
