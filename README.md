# GitHub Actions Kubernetes Toolkit
> This action started as a fork of [steebchen/kubectl](https://github.com/steebchen/kubectl), but the solution is now very different.
> If you just need to directly run a single kubernetes command, simply use that action.
> 
> If instead, you need to run multiple `kubectl` commands, or `helm`, this action installs these tools _and_ configures them,
> so that they can be used throughout the remaining steps in your job.

This action provides `kubectl` and `helm` for GitHub Actions.

As with the upstream inspiration for this project, please :star: it if you do end up using it!

## Usage

`.github/workflows/push.yml`

```yaml
on: push
name: deploy
jobs:
  deploy:
    name: deploy to cluster
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: deploy to cluster
      uses: bwvolleyball/k8s-toolkit@v1.0.0
      with: # defaults to latest kubectl & helm binary versions
        config: ${{ secrets.KUBE_CONFIG_DATA }}
        kubectl_version: v1.21.5
        helm_version: v3.7.0
    # After it's been configured, you can now freely use kubectl & helm commands the rest of the job.
    # This could also be used for multi-cluster deployment, as long as your provided kube config has all required clusters.
    - name: Check kubectl version
      run: kubectl version
    - name: Check helm version
      run: helm version
    - name: Update Deployment
      run: set image --record deployment/my-app container=${{ github.repository }}:${{ github.sha }}
    - name: Helm Deployment
      run: helm upgrade my-release my/chart --namespace namespace
    - name: verify deployment
      run: helm test my-release --namespace namespace
```

## Arguments

`config` – **required**: A base64-encoded kubeconfig file with credentials for Kubernetes to access the cluster. You can get it by running the following command:

```bash
cat $HOME/.kube/config | base64
```
**Note**: Do not use kubectl config view as this will hide the certificate-authority-data.

`kubectl_version`: The kubectl version with a 'v' prefix, e.g. `v1.21.0`. It defaults to the latest kubectl binary version available.

`helm_version`: The helm version with a 'v' prefix, e.g. `v3.7.0`. It defaults to the latest helm binary version available.
Since this is read from the GitHub releases, it could easily be a pre-release binary. You are strongly encouraged to explicitly
set the version for this.
