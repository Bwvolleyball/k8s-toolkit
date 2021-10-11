#!/bin/sh

set -e

kubectl_version="$1"
config="$2"
helm_version="$3"

if [ "$kubectl_version" = "latest" ]; then
  kubectl_version=$(curl -Ls https://dl.k8s.io/release/stable.txt)
fi

echo "using kubectl@$kubectl_version"

curl -sLO "https://dl.k8s.io/release/$kubectl_version/bin/linux/amd64/kubectl" -o kubectl
chmod +x kubectl
mv kubectl /usr/local/bin

# Extract the base64 encoded config data and write this to the KUBECONFIG
export KUBE_CONFIG_FOLDER="$GITHUB_WORKSPACE/.kube"
export KUBECONFIG="$KUBE_CONFIG_FOLDER/config"

mkdir -p "$KUBE_CONFIG_FOLDER"

echo "$config" | base64 -d > "$KUBECONFIG"
echo "KUBECONFIG=./.kube/config" >> "$GITHUB_ENV"

# Install helm
if [ "$helm_version" = "latest" ]; then
  helm_version=$(curl -s "https://api.github.com/repos/helm/helm/releases/latest" | awk -F '"' '/tag_name/{print $4}')
fi

echo "using helm@$helm_version"

curl -sLO "https://get.helm.sh/helm-$helm_version-linux-amd64.tar.gz" -o "helm-$helm_version-linux-amd64.tar.gz"
tar -zxvf "helm-$helm_version-linux-amd64.tar.gz"
mv linux-amd64/helm /usr/local/bin/helm
