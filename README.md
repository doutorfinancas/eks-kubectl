# EKS-Kubectl

[![GitHub License](https://img.shields.io/github/license/doutorfinancas/eks-kubectl)](https://github.com/doutorfinancas/eks-kubectl/blob/master/LICENSE)
[![GHCR Latest Tag](https://ghcr-badge.egpl.dev/doutorfinancas/eks-kubectl/latest_tag)](https://github.com/doutorfinancas/eks-kubectl/pkgs/container/eks-kubectl)

A Concourse CI resource for running kubectl commands against EKS clusters with AWS authentication.

## Description

This resource allows you to execute kubectl commands on Amazon EKS clusters, using AWS credentials for authentication. It's designed for use in Concourse CI pipelines to interact with Kubernetes resources securely.

## Why Use This?

Because we needed a simple script to authenticate to AWS and do a simple command for us.
We also needed different kubectl versions from the ones maintained, so, here we are.

## Usage

To use this resource in your Concourse pipeline, define it as a resource type and resource, then use it in jobs to run kubectl commands.

```yaml
resource_types:
- name: eks-kubectl
  type: registry-image
  source:
    repository: ghcr.io/doutorfinancas/eks-kubectl
    tag: 1.30

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

## Resource definition - Source

| Parameter Name        | Required | Description                                                                |
|-----------------------|----------|----------------------------------------------------------------------------|
| aws_access_key_id     | Yes      | AWS access key ID                                                          |
| aws_secret_access_key | Yes      | AWS secret access key                                                      |
| eks_cluster_name      | Yes      | Name of the EKS cluster                                                    |
| eks_region            | Yes      | AWS region of the EKS cluster                                              |
| namespace             | No       | Default Kubernetes namespace (defaults to 'default')                       |

## PUT - Params

Executes the specified kubectl command against the configured EKS cluster.

| Parameter Name | Required | Description                                                                                                                                  |
|----------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------|
| kubectl        | Yes      | The kubectl command to execute                                                                                            |
| namespace      | No       | Kubernetes namespace to use for this command (overrides source namespace)                                                                    |

## Contributing

Want more features? PRs are welcome :)

## Building from Source

To build and push the Docker image:

### Requirements

- Docker installed with Buildx support (for multi-platform builds).
- Bash shell.
- GitHub Personal Access Token (PAT) with `write:packages` scope for pushing to GHCR.
- Logged in to GHCR: Run `echo YOUR_GITHUB_CLASSIC_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin`.

### Steps

1. Clone the repository.
2. Run `make image-push`.
3. Enter the Kubernetes version number when prompted (e.g., 1.30).

This will build the image for arm64 and amd64 platforms, tag it with both the mentioned version and `latest`, and push to `ghcr.io/doutorfinancas/eks-kubectl`.

**Note:** You need push permissions to the repository's package registry. For contributors, consider adjusting the repository in `build-tools/tag.sh` for testing purposes.

## Available Versions

You can see the currently available kubectl versions in [GitHub Package Registry](https://github.com/doutorfinancas/eks-kubectl/pkgs/container/eks-kubectl).

Request more via issues or PRs.

## License

This project is licensed under the Apache License - see the [LICENSE](LICENSE) file for details.
